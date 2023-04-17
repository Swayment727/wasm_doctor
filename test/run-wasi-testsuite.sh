#! /bin/sh

set -e

DIR=.wasi-testsuite

fetch() {
    REPO=https://github.com/WebAssembly/wasi-testsuite
    # prod/testsuite-all branch
    REF=6cbd7e21bd40ce3cf405a646956085e2a0cd344c
    mkdir "${DIR}"
    git -C "${DIR}" init
    git -C "${DIR}" fetch --depth 1 ${REPO} ${REF}
    git -C "${DIR}" checkout FETCH_HEAD
}

if [ ! -d ${DIR} ]; then
    fetch
fi

TOYWASM=${TOYWASM:-toywasm}

FILTER_OPTIONS="--exclude-filter test/wasi-testsuite-skip.json"
if ${TOYWASM} --version | grep -F "sizeof(void *) = 4"; then
    FILTER_OPTIONS="${FILTER_OPTIONS} test/wasi-testsuite-skip-32bit.json"
fi

TESTS="${TESTS} assemblyscript/testsuite/"
TESTS="${TESTS} c/testsuite/"
TESTS="${TESTS} rust/testsuite/"

for t in ${TESTS}; do
    TESTDIRS="${TESTDIRS} ${DIR}/tests/${t}"
done

virtualenv venv
. ./venv/bin/activate
python3 -m pip install -r ${DIR}/test-runner/requirements.txt
python3 ${DIR}/test-runner/wasi_test_runner.py \
-t ${TESTDIRS} \
${FILTER_OPTIONS} \
-r test/wasi-testsuite-adapter.py
