# Golang time

## Golang Timeformat

Instead of having a convectional format to print the date. Go uses a reference date which seems meaningless buf if you see it this way it makes sense: it's `1 2 3 4 5 6`in the Posix `date`format:

```bash
Mon Jan 2 15:04:05 -0700 MST 2006
0   1   2  3  4  5              6
```



{% embed url="https://pkg.go.dev/time#pkg-constants" %}



## Convert String to Date in yyyy-mm-dd format

```go
yourDate, err := time.Parse("2006-01-02", youtString)
```





## Calculate Date & Change Date Formatting

### Get Current Date

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	now := time.Now()
	nowUTC := time.Now().UTC()
	nowUNIX := time.Now().Unix()
	fmt.Println(now)
	fmt.Println(nowUTC)
	fmt.Println(nowUNIX)
}

// 결과

// 2018-12-19 20:42:08.219845 +0900 KST m=+0.000394187
// 2018-12-19 11:42:08.219846 +0000 UTC
// 1545219728
```



### Change Date Formatting

```go
// constant of time package in standard library
const (
        ANSIC       = "Mon Jan _2 15:04:05 2006"
        UnixDate    = "Mon Jan _2 15:04:05 MST 2006"
        RubyDate    = "Mon Jan 02 15:04:05 -0700 2006"
        RFC822      = "02 Jan 06 15:04 MST"
        RFC822Z     = "02 Jan 06 15:04 -0700" // RFC822 with numeric zone
        RFC850      = "Monday, 02-Jan-06 15:04:05 MST"
        RFC1123     = "Mon, 02 Jan 2006 15:04:05 MST"
        RFC1123Z    = "Mon, 02 Jan 2006 15:04:05 -0700" // RFC1123 with numeric zone
        RFC3339     = "2006-01-02T15:04:05Z07:00"
        RFC3339Nano = "2006-01-02T15:04:05.999999999Z07:00"
        Kitchen     = "3:04PM"
        // Handy time stamps.
        Stamp      = "Jan _2 15:04:05"
        StampMilli = "Jan _2 15:04:05.000"
        StampMicro = "Jan _2 15:04:05.000000"
        StampNano  = "Jan _2 15:04:05.000000000"
)
```

```go
ackage main

import (
	"fmt"
	"time"
)

func main() {
	now := time.Now()
	custom := now.Format("2006-01-02 15:04:05")
	ansic := now.Format(time.ANSIC)
	fmt.Println(custom)
	fmt.Println(ansic)
}


// 결과
// 2018-12-19 20:41:21
// Wed Dec 19 20:41:21 2018
```



## Calculate Date

### Calculate Hours, Minutes



```go
import (
  "time"
)


func main() {
	now := time.Now()

	convMinutes, _ := time.ParseDuration("10m")
	convHours, _ := time.ParseDuration("1h")
	diffMinutes := now.Add(-convMinutes).Format("2006-01-02 15:04:05")
	diffHours := now.Add(-convHours).Format("2006-01-02 15:04:05")
	
	fmt.Println(now)
	fmt.Println(diffMinutes)
	fmt.Println(diffHours)
}


// 결과


// 2018-12-19 20:52:35.100418 +0900 KST m=+0.000385834
// 2018-12-19 20:42:35
// 2018-12-19 19:52:35
```

### Calculate Days, Months, Years

```go
import (
  "time"
)

func main() {
	now := time.Now()

	convDays := 1
	convMonths := 1
	convYears := 1

	diffDays := now.AddDate(0, 0, -convDays).Format("2006-01-02 15:04:05")
	diffMonths := now.AddDate(0, -convMonths, 0).Format("2006-01-02 15:04:05")
	diffYears := now.AddDate(-convYears, 0, 0).Format("2006-01-02 15:04:05")


	fmt.Println(now)
	fmt.Println(diffDays)
	fmt.Println(diffMonths)
	fmt.Println(diffYears)
}


// 결과
// 2018-12-19 21:00:23.506858 +0900 KST m=+0.000362007
// 2018-12-18 21:00:23
// 2018-11-19 21:00:23
// 2017-12-19 21:00:23
```



