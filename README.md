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
    - ./cf login -a https://api.run.pivotal.io -u brossierp@gmail.com -o brossierpPerso -s development

- Sign up for a cleardb instance:
    - cf create-service cleardb spark mysql

- Build the app:
    - mvn clean package

- Push the app. Its manifest assumes you called your ClearDB instance 'mysql':
    - cf push --hostname philippeSubDomain
    - Initial output was:
            - Using manifest file /home/centos/code_perso/cloudFoundryWorkWithPostgres/manifest.yml
            - Creating app cloudFoundryWorkWithPostgres in org brossierpPerso / space development as brossierp@gmail.com...
            OK
            - Creating route philippeSubDomain.cfapps.io...
            OK
            - Binding philippeSubDomain.cfapps.io to cloudFoundryWorkWithPostgres...
            OK
            - Uploading cloudFoundryWorkWithPostgres...
            Uploading app files from: /tmp/unzipped-app639290344
            Uploading 798.3K, 116 files
            Done uploading
            OK
            - Binding service mysql to app cloudFoundryWorkWithPostgres in org brossierpPerso / space development as brossierp@gmail.com...
            OK

            - Starting app cloudFoundryWorkWithPostgres in org brossierpPerso / space development as brossierp@gmail.com...
            Downloading java_buildpack...
            Downloaded java_buildpack
            Creating container
            Successfully created container
            Downloading app package...
            Downloaded app package (22.7M)
            Staging...
            -----> Java Buildpack Version: v3.8 (offline) | https://github.com/cloudfoundry/java-buildpack.git#29c79f2
            -----> Downloading Open Jdk JRE 1.8.0_91-unlimited-crypto from https://download.run.pivotal.io/openjdk/trusty/x86_64/openjdk-1.8.0_91-unlimited-crypto.tar.gz (found in cache)
            Expanding Open Jdk JRE to .java-buildpack/open_jdk_jre (1.0s)
            -----> Downloading Open JDK Like Memory Calculator 2.0.2_RELEASE from https://download.run.pivotal.io/memory-calculator/trusty/x86_64/memory-calculator-2.0.2_RELEASE.tar.gz (found in cache)
            Memory Settings: -Xss349K -Xmx681574K -XX:MaxMetaspaceSize=104857K -Xms681574K -XX:MetaspaceSize=104857K
            -----> Downloading Spring Auto Reconfiguration 1.10.0_RELEASE from https://download.run.pivotal.io/auto-reconfiguration/auto-reconfiguration-1.10.0_RELEASE.jar (found in cache)
            Exit status 0
            Staging complete
            Uploading droplet, build artifacts cache...
            Uploading build artifacts cache...
            Uploading droplet...
            Uploaded build artifacts cache (108B)
            Uploaded droplet (68.2M)
            Uploading complete

            - App started
            - App cloudFoundryWorkWithPostgres was started using this command `CALCULATED_MEMORY=$($PWD/.java-buildpack/open_jdk_jre/bin/java-buildpack-memory-calculator-2.0.2_RELEASE -memorySizes=metaspace:64m..,stack:228k.. -memoryWeights=heap:65,metaspace:10,native:15,stack:10 -memoryInitials=heap:100%,metaspace:100% -stackThreads=300 -totMemory=$MEMORY_LIMIT) && JAVA_OPTS="-Djava.io.tmpdir=$TMPDIR -XX:OnOutOfMemoryError=$PWD/.java-buildpack/open_jdk_jre/bin/killjava.sh $CALCULATED_MEMORY" && SERVER_PORT=$PORT eval exec $PWD/.java-buildpack/open_jdk_jre/bin/java $JAVA_OPTS -cp $PWD/. org.springframework.boot.loader.JarLauncher`

            - Showing health and status for app cloudFoundryWorkWithPostgres in org brossierpPerso / space development as brossierp@gmail.com...
            OK

- To verify the status in the web UI
    - https://console.run.pivotal.io/ with brossierp@gmail.com

- export HOST=http://philippeSubDomain.cfapps.io

- To delete the app if required:
    - cf delete cloudFoundryWorkWithPostgres


###################################################
# To test
###################################################
- To clear the database from any previous tests:
    - curl -v -X DELETE $HOST/all
    200

- To request a match as “andrew”:
    - curl -v -H "Content-Type: application/json" -X PUT $HOST/match_requests/firstrequest -d '{"player": "andrew"}'
    200 {"uuid":"firstrequest","requesterId":"andrew"}

- To request a match as a different player:
    - curl -v -H "Content-Type: application/json" -X PUT $HOST/match_requests/secondrequest -d '{"player": "navratilova"}'
    200 {"uuid":"secondrequest","requesterId":"navratilova"}

- To check the status of the first match request:
    - curl -v -X GET $HOST/match_requests/firstrequest
    200 {"match_id":"e1ab14f8-5197-4970-9e68-00ba63f4a928","id":"firstrequest","player":"andrew"}

- Replace MATCH_ID with the match_id value from the previous step in the following command:
    - curl -v -H "Content-Type: application/json" -X POST $HOST/results -d ' { "match_id":"e1ab14f8-5197-4970-9e68-00ba63f4a928", "winner":"andrew", "loser":"navratilova" }'
    201 {"winner":"andrew","loser":"navratilova","match_id":"e1ab14f8-5197-4970-9e68-00ba63f4a928"}


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
