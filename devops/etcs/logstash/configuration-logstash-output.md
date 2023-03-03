# Configuration Logstash Output

## Logstash 구성

Logstash pipeline 은 3가지로 구성되어 있다.

* Input
* Filter
* Output

Output 값은 다양한 방법으로 저장하여 다양하게 확인이 가능하다.

ex) stdout, file, elasticsearch, ...



{% embed url="https://www.elastic.co/guide/en/logstash/current/configuration-file-structure.html" %}



### 실습 환경 구성

#### Logstash 설치

Logstash 설치는 [여기](installing-logstash.md)에서 확인한다.



#### **실습조건**

> 3000 TCP port로 입력이 들어오면 파일로 저장하고, 표준출력으로 화면에 표시한다.



#### 실습을 위한 설정

`/etc/logstash/conf.d` 디렉토리에 새로운 파이프라인 설정을 추가한다. 파일의 이름은 `test_pipeline.conf`로 지정한다.

{% code overflow="wrap" %}
```ruby
input {
    tcp {
        port => 3000
        codec => json
    }
}

output {
    file {
        path => "/tmp/test_pipeline_logstash.log"
        codec => rubydebug
    }
    stdout {
        codec => json
    }
}
```
{% endcode %}



{% embed url="https://www.elastic.co/guide/en/logstash/current/codec-plugins.html" %}

nc 명령어로 json 파일을 logstash로 전한다.

{% code overflow="wrap" %}
```bash
echo "{\"Hello\":\"Logstash\"}" | nc 127.0.0.1 3000
```
{% endcode %}



tail 명령어로 logstash 에서 저장한 파일을 확인한다.

```bash
tail -F /tmp/test_pipeling_logstash.log
```

{% code overflow="wrap" %}
```bash
root@ubuntu-focal:~# tail -F /tmp/test_pipeline_logstash.log
tail: cannot open '/tmp/test_pipeline_logstash.log' for reading: No such file or directory
tail: '/tmp/test_pipeline_logstash.log' has appeared;  following new file
{
      "@version" => "1",
    "@timestamp" => 2023-02-02T08:55:35.950093170Z,
         "Hello" => "Logstash"
}
```
{% endcode %}
