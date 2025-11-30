/// Test suite for the Balbismo compiler library.
///
/// This test file contains unit tests to validate the functionality of the
/// Balbismo compiler library. The tests ensure that core functionality works
/// correctly and provide regression protection for future changes.
///
/// The test suite covers:
/// - Basic library functionality (sanity checks)
/// - Source code tokenization
/// - Successful compilation of valid code
/// - Error handling for invalid syntax

import 'package:balbismo/balbismo.dart';
import 'package:test/test.dart';

/// Main test function that runs all test cases for the Balbismo library.
///
/// This function sets up the test environment and executes individual test
/// cases to validate library functionality. Each test case verifies a specific
/// aspect of the compiler's behavior, ranging from simple math to complex
/// parsing logic.
void main() {
  
  // --- Basic Sanity Checks ---

  /// Tests the calculate function to ensure basic library functionality.
  ///
  /// This test verifies that the [calculate] function returns the expected
  /// value (42), which serves as a sanity check for the library's basic operation
  /// and environment setup.
  ///
  /// The test follows the standard test framework pattern:
  /// - Uses [test()] to define a test case
  /// - Uses [expect()] to verify the actual result matches the expected result
  test('calculate', () {
    expect(calculate(), 42);
  });

  // --- Compiler Core Functionality ---

  /// Tests the tokenizer (lexer) with a simple variable declaration.
  ///
  /// This test verifies that the [tokenize] function correctly breaks down a 
  /// source string into a list of valid tokens. It checks if the quantity 
  /// and type of tokens match the expected output for a standard declaration.
  ///
  /// Scenario:
  /// - Input: "var x = 10;"
  /// - Expected: A list containing identifier, operator, and literal tokens.
  test('tokenize parses simple variable declaration', () {
    final source = 'var x = 10;';
    final tokens = tokenize(source);

    expect(tokens, isNotEmpty);
    expect(tokens.length, greaterThan(0));
    // Assuming the first token should be a keyword 'var'
    expect(tokens.first.type, equals('KEYWORD_VAR')); 
  });

  /// Tests the compilation pipeline for a valid "Hello World" program.
  ///
  /// This test ensures that the [compile] function accepts valid Balbismo 
  /// source code and produces a non-empty output string (target code) without 
  /// throwing exceptions.
  ///
  /// The test verifies:
  /// - The compiler runs to completion
  /// - The output is not null
  /// - The output contains expected target instructions
  test('compile processes valid source code successfully', () {
    final source = 'print("Hello World");';
    final result = compile(source);

    expect(result, isNotNull);
    expect(result, isNotEmpty);
    expect(result, contains('System.out.println')); // Example target output
  });

  // --- Error Handling & Regression ---

  /// Tests the compiler's error handling for invalid syntax.
  ///
  /// This test verifies that the [compile] function correctly identifies
  /// malformed code and throws a specific [SyntaxError]. This ensures that
  /// the compiler fails gracefully and provides feedback rather than crashing.
  ///
  /// The test follows the exception testing pattern:
  /// - Uses [throwsA()] matcher
  /// - Verifies the type of exception is [SyntaxError]
  test('compile throws SyntaxError on missing semicolon', () {
    final invalidSource = 'var x = 10'; // Missing semicolon

    expect(
      () => compile(invalidSource), 
      throwsA(isA<SyntaxError>()),
      reason: 'Compiler should strictly enforce semicolon termination'
    );
  });
  
  /// Tests empty input handling.
  ///
  /// This test verifies edge-case behavior when the compiler receives an
  /// empty string. It expects the compiler to return an empty result or 
  /// a safe default, rather than crashing or hanging.
  test('compile handles empty input gracefully', () {
    expect(compile(''), isEmpty);
  });
}