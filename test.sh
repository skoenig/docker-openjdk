#!/bin/sh

cd $(dirname $0)/test

echo "Building test suite..."
javac jcetest/JCETest.java || exit $?
javac ssltest/SSLTest.java || exit $?
javac catest/CATest.java || exit $?

echo "Running tests..."

${JAVA_HOME+"false"} && ENV_RESULT=1 || ENV_RESULT=0
[ $ENV_RESULT -eq 0 ] && echo "TEST ENV: OK (JAVA_HOME is set)" || echo "TEST ENV: FAILED (JAVA_HOME not set)"

java jcetest.JCETest
JCE_RESULT=$?
[ $JCE_RESULT -eq 0 ] && echo "TEST JCE: OK (JCE is unlimited)" || echo "TEST JCE: FAILED (JCE is restricted)"

java ssltest.SSLTest
SSL_RESULT=$?
[ $SSL_RESULT -eq 0 ] && echo "TEST SSL: OK (SSL verification works)" || echo "TEST SSL: FAILED (SSL cannot be verified)"

java catest.CATest
CA_RESULT=$?
[ $CA_RESULT -eq 0 ] && echo "TEST CA: OK (CA is trusted)" || echo "TEST CA: FAILED (CA is not trusted)"

if [ $ENV_RESULT -eq 0 -a $JCE_RESULT -eq 0 -a $SSL_RESULT -eq 0 -a $CA_RESULT -eq 0 ]; then
	echo "Image verified!"
	exit 0
else
	echo "Image broken!"
	exit 1
fi
