# HTTP in C++

## C++ HTTP Post Method Example

{% code title="http_post.cpp" overflow="wrap" %}
```cpp
// --------------------------------------------------------------------
/*
	http_post.cpp

					May/27/2018

*/
// --------------------------------------------------------------------
#include	<string>
#include	<iostream>
#include	<cstring>

#include	<curl/curl.h>

using namespace std;

// --------------------------------------------------------------------
size_t callBackFunk(char* ptr, size_t size, size_t nmemb, string* stream)
{
	int realsize = size * nmemb;
	stream->append(ptr, realsize);
	return realsize;
}

// --------------------------------------------------------------------
string url_post_proc (const char url[],const char post_data[])
{
	CURL *curl;
	CURLcode res;
	curl = curl_easy_init();
	string chunk;

	if (curl)
		{
		curl_easy_setopt(curl, CURLOPT_URL, url);
		curl_easy_setopt(curl, CURLOPT_POST, 1);
		curl_easy_setopt(curl, CURLOPT_POSTFIELDS, post_data);
		curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, strlen(post_data));
		curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, callBackFunk);
		curl_easy_setopt(curl, CURLOPT_WRITEDATA, (string*)&chunk);
		curl_easy_setopt(curl, CURLOPT_PROXY, "");
		res = curl_easy_perform(curl);
		curl_easy_cleanup(curl);
		}
	if (res != CURLE_OK) {
		cout << "curl error" << endl;
		exit (1);
	}

	return chunk;
}

// --------------------------------------------------------------------
int main (int argc,char *argv[])
{
	cerr << "*** 開始 ***\n";

	char url_target[] = "https://httpbin.org/post";
	char post_data[] = "user=jiro&password=123456";

	string str_out = url_post_proc (url_target,post_data);

	cout << str_out << "\n";

	cerr << "*** 終了 ***\n";

	return 0;
}

// --------------------------------------------------------------------
```
{% endcode %}



{% code title="Makefile" overflow="wrap" %}
```makefile
http_post.exe: http_post.cpp
	clang++ -o http_post http_post.cpp -lcurl
clean:
	rm -f http_post
```
{% endcode %}



실행결과

```bash
$ ./http_post 
*** 開始 ***
{
  "args": {}, 
  "data": "", 
  "files": {}, 
  "form": {
    "password": "123456", 
    "user": "jiro"
  }, 
  "headers": {
    "Accept": "*/*", 
    "Content-Length": "25", 
    "Content-Type": "application/x-www-form-urlencoded", 
    "Host": "httpbin.org", 
    "X-Amzn-Trace-Id": "Root=1-5f25462e-4f05abfe4fb47190dc0ef00c"
  }, 
  "json": null, 
  "origin": "219.126.139.62", 
  "url": "https://httpbin.org/post"
}

*** 終了 ***
```



{% embed url="https://github.com/open-source-parsers/jsoncpp" %}

{% embed url="https://qiita.com/ekzemplaro/items/97bc000576a6210a3068" %}
