// Package p contains an HTTP Cloud Function.
package p

import (
	"fmt"
    "strconv"
    "time"
	"net/http"
)

var (
    startTime = time.Date(2019, time.October, 14, 0, 0, 0, 0, time.UTC)
    endTime  = time.Date(2020, time.April, 14, 0, 0, 0, 0, time.UTC)
)

func IsItTheWinterBreakYet(w http.ResponseWriter, r *http.Request) {
    fmt.Fprint(w, "{\"is_winter_break_yet\":\"" + strconv.FormatBool(isWinterBreakYet()) + "\", \"winter_break\": {\"start_time\":\"" + startTime.Format(time.RFC3339) + "\", \"end_time\":\"" + endTime.Format(time.RFC3339) + "\"}}")
}

func isWinterBreakYet() bool {
    callTime := time.Now()
 	return startTime.Before(callTime) && endTime.After(callTime)
}