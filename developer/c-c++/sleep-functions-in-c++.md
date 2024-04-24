# Sleep Functions in C++



C++ provides the functionality of delay or inactive state with the help of the operating system for a specific period of time. Other CPU operations will function adequately but the Sleep() function in C++ will sleep the present executable for the specified time by the thread. It can be implemented using 2 libraries according to the operating system being used:

```cpp
#include<windows.h>           // for windows

#include<unistd.h>               // for linux 
```



## Sleep

Sleep can suspend execution for time\_period where time\_period is in seconds by default although we can change it to microseconds.

**Syntax:**

```cpp
sleep( time_period );    // time_period in seconds
```

**Parameter:**  time\_period is in seconds it represents the sleep time taken.

**Return Type:**  The return type of sleep function is an integer where if the function is successfully executed then the value returned will be 0, else minus the value of the time period returned.

**Example:**&#x20;

```cpp
// C++ Program to show how to use
// sleep function
#include <iostream>

// Library effective with Windows
#include <windows.h>

// Library effective with Linux
#include <unistd.h>

using namespace std;

// Driver code
int main()
{
    cout << "Join the Line:\n";
    cout << "Wait for 5 seconds\n";

    // sleep will schedule rest of 
    // activities after 10 seconds
    sleep(5);

    cout << "It's your time buy ticket";
}

```

**Output:**

{% embed url="https://media.geeksforgeeks.org/wp-content/uploads/20220928093654/20220928_093523.mp4" %}

## Similar Functions Like sleep in C++

### **1. usleep():**&#x20;

This function is mostly similar to sleep but can only be used with \<unistd.h> library.

**Syntax:**

```cpp
usleep(time_period)   // time_period in microseconds
```

**Parameter:**  It takes time\_period where time\_period is by default in microseconds. 1 second = 10^6 microseconds.

**Return Type:**  Integer where it returns 0 if successful, and (-1 or -exp) if the process failed.

**Example:**&#x20;

```cpp
// C++ Program to show the 
// use of usleep function
#include <iostream>
#include <unistd.h>

using namespace std;

int main()
{
	cout << "Take your Position\n";

	// sleep for 10 seconds
	cout << "Wait for 5 seconds\n";
	usleep(5000000);

	cout << "Run! Run!";
	return 0;
}

```

**Output:**

{% embed url="https://media.geeksforgeeks.org/wp-content/uploads/20220928103716/20220928_103406.mp4" %}



### **2. sleep\_for():**&#x20;

Schedules thread for the specified time. It acts like a delay just like sleep function. However, It is possible that threads take more time than the scheduled time due to scheduling activities or can be resource contention delays. Library used \<thread>.

**Syntax:**

```cpp
this_<thread_name>::sleep_for(chorno:: time_duration (time_period))         
```

**Parameter:**  time\_period ( time for which thread is acquired )

**Example:**

```cpp
// C++ Program to demonstrate 
// sleep_for()function
#include <iostream>
#include <chrono>
#include <thread>
using namespace std;

// Driver cpde
int main()
{
    cout << "Thread is running\n";

    // Thread delayed for 5 seconds
    this_thread::sleep_for(chrono::milliseconds(5000));

    cout << "Thread was acquired for 5 seconds\n";

    return 0;
}

```

**Output:**

{% embed url="https://media.geeksforgeeks.org/wp-content/uploads/20220928111313/20220928_111216.mp4" %}



### **3. sleep\_until():**&#x20;

Blocks the execution of a thread until the sleep\_time is finished. However, even when sleep\_time has been reached due to scheduling or resource contention delays it could take more time than sleep\_time. Library used \<thread>.

**Syntax:**

```cpp
this_<thread_name>::sleep_until(awake_time) 
```

**Parameter:**  Sleep\_time (same time for which thread is blocked for execution)

**Example:**

```cpp
// C++ Program to demonstrate
// sleep_until()
#include <chrono>
#include <iostream>
#include <thread>

// Functioning returning 
// current time
auto now() 
{
	return std::chrono::steady_clock::now(); 
}

// Function calculating sleep time 
// with 2000ms delay
auto awake_time()
{
	using std::chrono::operator"" ms;
	return now() + 2000ms;
}

// Driver code
int main()
{
	std::cout << "Starting the operation .....\n" << std::flush;

	// Calculating current time
	const auto start{ now() };

	// using the sleep_time to delay
	// and calculating sleep time
	// using awake_time function
	std::this_thread::sleep_until(awake_time());

	// storing time for printing
	std::chrono::duration<double, std::milli> elapsed{
		now() - start
	};

	// printing waiting time
	std::cout << "Waited for : " << elapsed.count() << " ms\n";
}

```

**Output:**

{% embed url="https://media.geeksforgeeks.org/wp-content/uploads/20220926174404/20220926_173952.mp4" %}



{% embed url="https://www.geeksforgeeks.org/sleep-function-in-cpp/" %}
