# GeeksforGeeks

Last Updated : 12 Oct, 2022

C++ provides the functionality of delay or inactive state with the help of the operating system for a specific period of time. Other CPU operations will function adequately but the Sleep() function in C++ will sleep the present executable for the specified time by the thread. It can be implemented using 2 libraries according to the operating system being used:

> \#include\<windows.h>           // for windows
>
> \#include\<unistd.h>               // for linux&#x20;

Sleep can suspend execution for time\_period where time\_period is in seconds by default although we can change it to microseconds.

**Syntax:**

> **sleep( time\_period );**    // time\_period in seconds

**Parameter:**  time\_period is in seconds it represents the sleep time taken.

**Return Type:**  The return type of sleep function is an integer where if the function is successfully executed then the value returned will be 0, else minus the value of the time period returned.

**Example:**&#x20;

### C++

`#include <iostream>`

`#include <windows.h>`

`#include <unistd.h>`

`using` `namespace` `std;`

`int` `main()`

`{`

&#x20; `cout << "Join the Line:\n";`

&#x20; `cout << "Wait for 5 seconds\n";`

&#x20; `sleep(5);`

&#x20; `cout << "It's your time buy ticket";`

`}`

**Output:**

[https://media.geeksforgeeks.org/wp-content/uploads/20220928093654/20220928\_093523.mp4](https://media.geeksforgeeks.org/wp-content/uploads/20220928093654/20220928\_093523.mp4)

#### Similar Functions Like sleep in C++

**1. usleep():** This function is mostly similar to sleep but can only be used with \<unistd.h> library.

**Syntax:**

> &#x20;**usleep(time\_period)**   // time\_period in microseconds

**Parameter:**  It takes time\_period where time\_period is by default in microseconds. 1 second = 10^6 microseconds.

**Return Type:**  Integer where it returns 0 if successful, and (-1 or -exp) if the process failed.

**Example:**&#x20;

### C++

`#include <iostream>`

`#include <unistd.h>`

`using` `namespace` `std;`

`int` `main()`

`{`

&#x20;   `cout << "Take your Position\n";`

&#x20;   `cout << "Wait for 5 seconds\n";`

&#x20;   `usleep(5000000);`

&#x20;   `cout << "Run! Run!";`

&#x20;   `return` `0;`

`}`

**Output:**

[https://media.geeksforgeeks.org/wp-content/uploads/20220928103716/20220928\_103406.mp4](https://media.geeksforgeeks.org/wp-content/uploads/20220928103716/20220928\_103406.mp4)

**2. sleep\_for():** Schedules thread for the specified time. It acts like a delay just like sleep function. However, It is possible that threads take more time than the scheduled time due to scheduling activities or can be resource contention delays. Library used \<thread>.

**Syntax:**

> this\_\<thread\_name>::sleep\_for(chorno:: time\_duration (time\_period))        &#x20;

**Parameter:**  time\_period ( time for which thread is acquired )

**Example:**

### C++

`#include <iostream>`

`#include <chrono>`

`#include <thread>`

`using` `namespace` `std;`

`int` `main()`

`{`

&#x20; `cout << "Thread is running\n";`

&#x20; `this_thread::sleep_for(chrono::milliseconds(5000));`

&#x20; `cout << "Thread was acquired for 5 seconds\n";`

&#x20; `return` `0;`

`}`

**Output:**

[https://media.geeksforgeeks.org/wp-content/uploads/20220928111313/20220928\_111216.mp4](https://media.geeksforgeeks.org/wp-content/uploads/20220928111313/20220928\_111216.mp4)

**3. sleep\_until():** Blocks the execution of a thread until the sleep\_time is finished. However, even when sleep\_time has been reached due to scheduling or resource contention delays it could take more time than sleep\_time. Library used \<thread>.

**Syntax:**

> this\_\<thread\_name>::sleep\_until(awake\_time)&#x20;

**Parameter:**  Sleep\_time (same time for which thread is blocked for execution)

**Example:**

### C++

`#include <chrono>`

`#include <iostream>`

`#include <thread>`

`auto` `now()`

`{`

&#x20; `return` `std::chrono::steady_clock::now();`

`}`

`auto` `awake_time()`

`{`

&#x20; `using` `std::chrono::operator""` `ms;`

&#x20; `return` `now() + 2000ms;`

`}`

`int` `main()`

`{`

&#x20; `std::cout << "Starting the operation .....\n"` `<<`

&#x20;               `std::flush;`

&#x20; `const` `auto` `start{ now() };`

&#x20; `std::this_thread::sleep_until(awake_time());`

&#x20; `std::chrono::duration<double, std::milli> elapsed{`

&#x20;     `now() - start`

&#x20; `};`

&#x20; `std::cout << "Waited for : "` `<<`

&#x20;               `elapsed.count() << " ms\n";`

`}`

**Output:**

[https://media.geeksforgeeks.org/wp-content/uploads/20220926174404/20220926\_173952.mp4](https://media.geeksforgeeks.org/wp-content/uploads/20220926174404/20220926\_173952.mp4)

\
\


Like Article

Suggest improvement

Share your thoughts in the comments

#### Please Login to comment...
