import ballerina/io;
import ballerina/os;
import ballerina/regex;
import ballerina/test;

const string INCORRECT_NUMBER_OF_LINES = "incorrect number of lines in output";
const string UTF_8 = "UTF-8";
const string LOG_MESSAGE_INFO_FILE = "tests/resources/log-messages/info.bal";
const string LOG_MESSAGE_WARN_FILE = "tests/resources/log-messages/warn.bal";
const string LOG_MESSAGE_DEBUG_FILE = "tests/resources/log-messages/debug.bal";
const string LOG_MESSAGE_ERROR_FILE = "tests/resources/log-messages/error.bal";
const string LOG_LEVEL_FILE = "tests/resources/log-levels/main.bal";
const string CONFIG_DEBUG_FILE = "tests/resources/config/debug/Config.toml";
const string CONFIG_ERROR_FILE = "tests/resources/config/error/Config.toml";
const string CONFIG_INFO_FILE = "tests/resources/config/info/Config.toml";
const string CONFIG_WARN_FILE = "tests/resources/config/warn/Config.toml";

const string LEVEL_DEBUG = "level = DEBUG";
const string LEVEL_ERROR = "level = ERROR";
const string LEVEL_INFO = "level = INFO";
const string LEVEL_WARN = "level = WARN";
const string PACKAGE = "module = \"\"";
const string MESSAGE_INFO = "message = \"info log\"";
const string MESSAGE_DEBUG = "message = \"debug log\"";
const string MESSAGE_ERROR = "message = \"error log\"";
const string MESSAGE_WARN = "message = \"warn log\"";
const string KEY_VALUES1 = "foo = true id = 845315 username = \"Alex92\"";
const string KEY_VALUES2 = "id = 845315 username = \"Alex92\"";

configurable string bal_exec_path = ?;

@test:Config {}
public function testPrintDebug() {
    os:Process|error execResult = os:exec(bal_exec_path, {BALCONFIGFILE: CONFIG_DEBUG_FILE}, (), "run", LOG_MESSAGE_DEBUG_FILE);
    os:Process result = checkpanic execResult;
    int waitForExit = checkpanic result.waitForExit();
    int exitCode = checkpanic result.exitCode();
    io:ReadableByteChannel readableResult = result.stderr();
    io:ReadableCharacterChannel sc = new (readableResult, UTF_8);
    string outText = checkpanic sc.read(100000);
    string[] logLines = regex:split(outText, "\n");
    test:assertEquals(logLines.length(), 9, INCORRECT_NUMBER_OF_LINES);
    validateLog(logLines[6], LEVEL_DEBUG, PACKAGE, MESSAGE_DEBUG, "");
    validateLog(logLines[7], LEVEL_DEBUG, PACKAGE, MESSAGE_DEBUG, KEY_VALUES1);
    validateLog(logLines[8], LEVEL_DEBUG, PACKAGE, MESSAGE_DEBUG, KEY_VALUES2);
}

@test:Config {}
public function testPrintError() {
    os:Process|error execResult = os:exec(bal_exec_path, {}, (), "run", LOG_MESSAGE_ERROR_FILE);
    os:Process result = checkpanic execResult;
    int waitForExit = checkpanic result.waitForExit();
    int exitCode = checkpanic result.exitCode();
    io:ReadableByteChannel readableResult = result.stderr();
    io:ReadableCharacterChannel sc = new (readableResult, UTF_8);
    string outText = checkpanic sc.read(100000);
    string[] logLines = regex:split(outText, "\n");
    test:assertEquals(logLines.length(), 9, INCORRECT_NUMBER_OF_LINES);
    validateLog(logLines[6], LEVEL_ERROR, PACKAGE, MESSAGE_ERROR, "");
    validateLog(logLines[7], LEVEL_ERROR, PACKAGE, MESSAGE_ERROR, KEY_VALUES1);
    validateLog(logLines[8], LEVEL_ERROR, PACKAGE, MESSAGE_ERROR, KEY_VALUES2);
}

@test:Config {}
public function testPrintInfo() {
    os:Process|error execResult = os:exec(bal_exec_path, {}, (), "run", LOG_MESSAGE_INFO_FILE);
    os:Process result = checkpanic execResult;
    int waitForExit = checkpanic result.waitForExit();
    int exitCode = checkpanic result.exitCode();
    io:ReadableByteChannel readableResult = result.stderr();
    io:ReadableCharacterChannel sc = new (readableResult, UTF_8);
    string outText = checkpanic sc.read(100000);
    string[] logLines = regex:split(outText, "\n");
    test:assertEquals(logLines.length(), 9, INCORRECT_NUMBER_OF_LINES);
    validateLog(logLines[6], LEVEL_INFO, PACKAGE, MESSAGE_INFO, "");
    validateLog(logLines[7], LEVEL_INFO, PACKAGE, MESSAGE_INFO, KEY_VALUES1);
    validateLog(logLines[8], LEVEL_INFO, PACKAGE, MESSAGE_INFO, KEY_VALUES2);
}

@test:Config {}
public function testPrintWarn() {
    os:Process|error execResult = os:exec(bal_exec_path, {}, (), "run", LOG_MESSAGE_WARN_FILE);
    os:Process result = checkpanic execResult;
    int waitForExit = checkpanic result.waitForExit();
    int exitCode = checkpanic result.exitCode();
    io:ReadableByteChannel readableResult = result.stderr();
    io:ReadableCharacterChannel sc = new (readableResult, UTF_8);
    string outText = checkpanic sc.read(100000);
    string[] logLines = regex:split(outText, "\n");
    test:assertEquals(logLines.length(), 9, INCORRECT_NUMBER_OF_LINES);
    validateLog(logLines[6], LEVEL_WARN, PACKAGE, MESSAGE_WARN, "");
    validateLog(logLines[7], LEVEL_WARN, PACKAGE, MESSAGE_WARN, KEY_VALUES1);
    validateLog(logLines[8], LEVEL_WARN, PACKAGE, MESSAGE_WARN, KEY_VALUES2);
}

@test:Config {}
public function testErrorLevel() {
    os:Process|error execResult = os:exec(bal_exec_path, {BALCONFIGFILE: CONFIG_ERROR_FILE}, (), "run", LOG_LEVEL_FILE);
    os:Process result = checkpanic execResult;
    int waitForExit = checkpanic result.waitForExit();
    int exitCode = checkpanic result.exitCode();
    io:ReadableByteChannel readableResult = result.stderr();
    io:ReadableCharacterChannel sc = new (readableResult, UTF_8);
    string outText = checkpanic sc.read(100000);
    string[] logLines = regex:split(outText, "\n");
    test:assertEquals(logLines.length(), 7, INCORRECT_NUMBER_OF_LINES);
    validateLog(logLines[6], LEVEL_ERROR, PACKAGE, MESSAGE_ERROR, "");
}

@test:Config {}
public function testWarnLevel() {
    os:Process|error execResult = os:exec(bal_exec_path, {BALCONFIGFILE: CONFIG_WARN_FILE}, (), "run", LOG_LEVEL_FILE);
    os:Process result = checkpanic execResult;
    int waitForExit = checkpanic result.waitForExit();
    int exitCode = checkpanic result.exitCode();
    io:ReadableByteChannel readableResult = result.stderr();
    io:ReadableCharacterChannel sc = new (readableResult, UTF_8);
    string outText = checkpanic sc.read(100000);
    string[] logLines = regex:split(outText, "\n");
    test:assertEquals(logLines.length(), 8, INCORRECT_NUMBER_OF_LINES);
    validateLog(logLines[6], LEVEL_ERROR, PACKAGE, MESSAGE_ERROR, "");
    validateLog(logLines[7], LEVEL_WARN, PACKAGE, MESSAGE_WARN, "");
}

@test:Config {}
public function testInfoLevel() {
    os:Process|error execResult = os:exec(bal_exec_path, {BALCONFIGFILE: CONFIG_INFO_FILE}, (), "run", LOG_LEVEL_FILE);
    os:Process result = checkpanic execResult;
    int waitForExit = checkpanic result.waitForExit();
    int exitCode = checkpanic result.exitCode();
    io:ReadableByteChannel readableResult = result.stderr();
    io:ReadableCharacterChannel sc = new (readableResult, UTF_8);
    string outText = checkpanic sc.read(100000);
    string[] logLines = regex:split(outText, "\n");
    test:assertEquals(logLines.length(), 9, INCORRECT_NUMBER_OF_LINES);
    validateLog(logLines[6], LEVEL_ERROR, PACKAGE, MESSAGE_ERROR, "");
    validateLog(logLines[7], LEVEL_WARN, PACKAGE, MESSAGE_WARN, "");
    validateLog(logLines[8], LEVEL_INFO, PACKAGE, MESSAGE_INFO, "");
}

@test:Config {}
public function testDebugLevel() {
    os:Process|error execResult = os:exec(bal_exec_path, {BALCONFIGFILE: CONFIG_DEBUG_FILE}, (), "run", LOG_LEVEL_FILE);
    os:Process result = checkpanic execResult;
    int waitForExit = checkpanic result.waitForExit();
    int exitCode = checkpanic result.exitCode();
    io:ReadableByteChannel readableResult = result.stderr();
    io:ReadableCharacterChannel sc = new (readableResult, UTF_8);
    string outText = checkpanic sc.read(100000);
    string[] logLines = regex:split(outText, "\n");
    test:assertEquals(logLines.length(), 10, INCORRECT_NUMBER_OF_LINES);
    validateLog(logLines[6], LEVEL_ERROR, PACKAGE, MESSAGE_ERROR, "");
    validateLog(logLines[7], LEVEL_WARN, PACKAGE, MESSAGE_WARN, "");
    validateLog(logLines[8], LEVEL_INFO, PACKAGE, MESSAGE_INFO, "");
    validateLog(logLines[9], LEVEL_DEBUG, PACKAGE, MESSAGE_DEBUG, "");
}

isolated function validateLog(string log, string level, string package, string message, string keyValues) {
    test:assertTrue(log.includes(level));
    test:assertTrue(log.includes(package));
    test:assertTrue(log.includes(message));
    test:assertTrue(log.includes(keyValues));
}
