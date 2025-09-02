# Graylog API Tools

Tools to interact with Graylog's API. Not much here as of now.

# Tools

## create-inputs-test

Bash script that can be used to quickly create and delete a large number of inputs

Requires configuring `config.sh`.

Instructions to run:

1. copy `config.sh.example` to `config.sh`
2. set values for `GRAYLOG_URL_BASE` and `GRAYLOG_API_TOKEN`
3. Uncomment lines in the main function depending on what you want to do:
    * `DELETE_ALL_RANDOM_INPUTS` - Deletes ALL inputs of type `org.graylog2.inputs.random.FakeHttpMessageInput`
    * `CREATE_MANY_MANY_RANDOM_INPUTS <number>` - creates a specified number of inputs of type `org.graylog2.inputs.random.FakeHttpMessageInput`
4. execute create-inputs-test.sh