###################################################
# Introduction
###################################################
- Started from https://docs.cloudfoundry.org/buildpacks/java/gsg-spring.html

- Sample app obtained with:
    - git clone https://github.com/cloudfoundry-samples/pong_matcher_spring
    - copied to /cloudFoundryWorkWithPostgres so we can amend README, etc.


###################################################
# CF example app: ping-pong matching server
###################################################
This is an app to match ping-pong players with each other. It's currently an API only, so you have to use `curl` to interact with it.

It has an [acceptance test suite][acceptance-test] you might like to look at.

**Note**: We highly recommend that you use the latest versions of any software required by this sample application. For example, make sure that you are using the most recent version of Maven.


###################################################
# Install Cloud Foundry CLI (followed https://docs.cloudfoundry.org/cf-cli/install-go-cli.html)
###################################################
cd /nfshome/philippe.brossier/code_perso/cloudFoundryWorkWithPostgres
curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar -zx
To verify it is working:./cf help


###################################################
# Running on [Pivotal Web Services][pws]
###################################################
- Log into ORG = brossierpPerso and SPACE = development:
    - details of ORG and SPACE found by logging into https://console.run.pivotal.io/ with brossierp@gmail.com
    - switch to ONS-Guest wifi
    - cf login -a https://api.run.pivotal.io -u brossierp@gmail.com -p yourPassword -o brossierpPerso -s development

- Sign up for a cleardb instance (note mysql defined in //cloudFoundryWorkWithPostgres/manifest.yml):
    - cf create-service cleardb spark mysql

- Build the app:
    - mvn clean package

- Push the app. Its manifest assumes you called your ClearDB instance 'mysql':
    - cf push --hostname philippemysql

- To verify the status in the web UI
    - https://console.run.pivotal.io/ with brossierp@gmail.com

- To delete the app if required:
    - cf delete cloudFoundryWorkWithPostgres
    - also remember services: cf delete-service mysqlpb


###################################################
# To test
###################################################
- To clear the database from any previous tests:
    - curl -v -X DELETE http://philippemysql.cfapps.io/all
    200

- To request a match as “andrew”:
    - curl -v -H "Content-Type: application/json" -X PUT http://philippemysql.cfapps.io/match_requests/firstrequest -d '{"player": "andrew"}'
    200 {"uuid":"firstrequest","requesterId":"andrew"}

- To request a match as a different player:
    - curl -v -H "Content-Type: application/json" -X PUT http://philippemysql.cfapps.io/match_requests/secondrequest -d '{"player": "navratilova"}'
    200 {"uuid":"secondrequest","requesterId":"navratilova"}

- To check the status of the first match request:
    - curl -v -X GET http://philippemysql.cfapps.io/match_requests/firstrequest
    200 {"match_id":"2762ffb5-55f9-447a-8dc6-816aa0c5e12b","id":"firstrequest","player":"andrew"}

- Replace MATCH_ID with the match_id value from the previous step in the following command:
    - curl -v -H "Content-Type: application/json" -X POST http://philippemysql.cfapps.io/results -d ' { "match_id":"2762ffb5-55f9-447a-8dc6-816aa0c5e12b", "winner":"andrew", "loser":"navratilova" }'
    201 {"winner":"andrew","loser":"navratilova","match_id":"2762ffb5-55f9-447a-8dc6-816aa0c5e12b"}


###################################################
# Running locally
###################################################
- Install and start mysql:
    - yum install mysql
    - mysql.server start
    - mysql -u root

- Create a database user and table in the MySQL REPL you just opened:
    - CREATE USER 'springpong'@'localhost' IDENTIFIED BY 'springpong';
    - CREATE DATABASE pong_matcher_spring_development;
    - GRANT ALL ON pong_matcher_spring_development.* TO 'springpong'@'localhost';
    - exit

- Start the application server from your IDE or the command line:
    - mvn spring-boot:run

- Export the test host
    - export HOST=http://localhost:8080

- Follow the 'To test' section above.
