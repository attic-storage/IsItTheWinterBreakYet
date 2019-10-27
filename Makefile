PROJECT:=winter-break
REGION:=europe-west1
FUNCTION_NAME:=IsItTheWinterBreakYet
FUNCTION_URL:=https://$(REGION)-$(PROJECT).cloudfunctions.net/$(FUNCTION_NAME)
FRONTPAGE_NAME:=index.html
FRONTPAGE_URL:=https://storage.googleapis.com/$(PROJECT)/$(FRONTPAGE_NAME)

configure:
	gcloud config set project $(PROJECT)
	gcloud config set functions/region $(REGION)

# FUNCTION
deploy-function: configure
	gcloud functions deploy $(FUNCTION_NAME) --entry-point=$(FUNCTION_NAME) --memory=128MB --max-instances=5 --runtime go111 --trigger-http

delete-function: configure
	gcloud functions delete $(FUNCTION_NAME)

get-function-url:
	@echo $(FUNCTION_URL)

run-function:
	@curl -sL $(FUNCTION_URL) | jq
	
# FRONTPAGE
deploy-bucket: configure
	gsutil ls | grep "^gs://$(PROJECT)/" >/dev/null || gsutil mb -l $(REGION) gs://$(PROJECT)/

dist/$(FRONTPAGE_NAME):
	@mkdir -p dist
	@sed 's#FUNCTION_URL#$(FUNCTION_URL)#' $(FRONTPAGE_NAME) > dist/$(FRONTPAGE_NAME)

deploy-frontpage: dist/$(FRONTPAGE_NAME) deploy-bucket 
	gsutil cp dist/$(FRONTPAGE_NAME) gs://$(PROJECT)/$(FRONTPAGE_NAME)
	gsutil acl ch -r -u AllUsers:R gs://$(PROJECT)/$(FRONTPAGE_NAME)

get-frontpage-url: configure
	@echo $(FRONTPAGE_URL)

run-frontpage:
	@open $(FRONTPAGE_URL)

.PHONY: configure deploy-function delete-function get-frontpage-url get-function-url run-function
