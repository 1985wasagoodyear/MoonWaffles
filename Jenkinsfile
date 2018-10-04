node('master') {

    stage('Checkout/Build/Test') {

        // Checkout files.
        checkout([
            $class: 'GitSCM',
            branches: [[name: 'master']],
            doGenerateSubmoduleConfigurations: false,
            extensions: [], submoduleCfg: [],
            userRemoteConfigs: [[
                name: 'github',
                url: 'https://github.com/1985wasagoodyear/MoonWaffles'
            ]]
        ])

        // Build and Test
        sh 'xcodebuild -scheme "MoonWaffles" -configuration "Debug" build test -destination "platform=iOS Simulator,name=iPhone X,OS=12.0" -enableCodeCoverage YES' 
        // | /usr/local/bin/xcpretty -r junit'

        // Publish test restults.
        // step([$class: 'JUnitResultArchiver', allowEmptyResults: true, testResults: 'build/reports/junit.xml'])
    }

    stage ('Notify') {
        // Send slack notification
        // slackSend channel: '#my-team', message: 'Time Table - Successfully', teamDomain: 'my-team', token: 'my-token'
    }
}