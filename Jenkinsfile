#!/usr/bin/env groovy
@Library('github.com/msrb/cicd-pipeline-helpers')

def commitId
node('docker') {

    def image = docker.image('bayesian/gremlin')

    stage('Checkout') {
        checkout scm
        commitId = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
        dir('openshift') {
            stash name: 'template', includes: 'template.yaml'
        }
    }

    stage('Build') {
        dockerCleanup()
        docker.build(image.id, '--pull --no-cache .')
    }

	// we don't have any tests for gremlin! :(

    if (env.BRANCH_NAME == 'master') {
        stage('Push Images') {
            docker.withRegistry('https://registry.devshift.net/') {
                image.push('latest')
                image.push(commitId)
            }
        }
    }
}

if (env.BRANCH_NAME == 'master') {
    node('oc') {
        stage('Deploy - dev') {
            unstash 'template'
            sh "oc --context=dev process -v REST_VALUE=1 -v IMAGE_TAG=${commitId} -v CHANNELIZER=http -f template.yaml | oc --context=dev apply -f -"
        }

        stage('Deploy - rh-idev') {
            unstash 'template'
            sh "oc --context=rh-idev process -v REST_VALUE=1 -v IMAGE_TAG=${commitId} -v CHANNELIZER=http -f template.yaml | oc --context=rh-idev apply -f -"
        }
    }
}

