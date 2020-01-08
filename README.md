Wrap [dehydrated](https://github.com/lukas2511/dehydrated) & [lexicon](https://github.com/AnalogJ/lexicon) by docker for Let's Encrypt & ACME challenge.

Automatic update certificates every month to do DNS challenge by API. Only support AWS route53 currently


## Usage

#### Prepare

1. Add `config/aws` for awscli, the folder need include `config` & `credentials`

    config example:
    ```
    [default]
    output = json
    region = us-west-2
    ```

    credentials example:
    ```
    [default]
    aws_access_key_id = {YOUR-ACCESS-KEY}
    aws_secret_access_key = {SECRET-ACCESS-KEY}
    ```

2. Add config/domains.txt, for the domain you want to applied
    example:
    ```
    *.example.com > star_example_com
    ```


#### Execution
use docker-compose to build and run in background cronjob

```shell
$ docker-compose build
$ docker-compose up -d
```

## Certificates
Check and update at 1st & 15th day every month

1. `./accounts` the register account information
2. `./certs` the certificates result
it could be apply in Nginx like below
```
server {
    # ...
    ssl_certificate     {MOUNT-DIR}/certs/fullchain.pem;
    ssl_certificate_key {MOUNT-DIR}/certs/privkey.pem;
}
```

## Debug
Modify docker-compose.yml, un-comment volumes bind on `./config/dehydrated.stage.config` to use stage CA to apply Let's Encrypt

