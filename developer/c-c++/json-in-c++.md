# JSON in C++

```cpp
#include "json/json.h"
#include "json/json-forwards.h"

std::string createJson()
{
        Json::Value root;
        root["body"] = "[[PizzaHouse]](http://url_to_text) You have a new Pizza order.";

        root["connectColor"] = "#FAC11B";

        Json::Value connectInfo;

        Json::Value title1;
        title1["title"] = "Topping";
        title1["description"] = "Pepperoni";
        connectInfo.append(title1);

        Json::Value title2;
        title2["title"] = "Location";
        title2["description"] = "Empire State Building, 5th Ave, New York";
        connectInfo.append(title2);

        Json::Value title3;
        title3["title"] = "Who am I?";
        title3["description"] = "Cpp Http Send Test";
        connectInfo.append(title3);

        root["connectInfo"] = connectInfo;

        Json::StyledWriter writer;
        return writer.write(root);
}

int main(int argc, char** argv)
{
        std::string jsonString = createJson();
        std::cout << jsonString << std::endl;
        
        return 0;
}
```



실행결과

```bash
$ ./json_test
{
   "body" : "[[PizzaHouse]](http://url_to_text) You have a new Pizza order.",
   "connectColor" : "#FAC11B",
   "connectInfo" : [
      {
         "description" : "Pepperoni",
         "title" : "Topping"
      },
      {
         "description" : "Empire State Building, 5th Ave, New York",
         "title" : "Location"
      },
      {
         "description" : "Cpp Http Send Test",
         "title" : "Who am I?"
      }
   ]
}

```





{% embed url="https://github.com/open-source-parsers/jsoncpp" %}
