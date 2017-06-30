@local @local_codechecker
Feature: Codechecker UI works as expected
  In order to verify coding style
  As an admin
  I need to be able to use codechecker UI with success

  Scenario: Verify that specified paths are checked
    Given I log in as "admin"
    And I navigate to "Development > Code checker" in site administration

    When I set the field "Path to check" to "index.php"
    And I press "Check code"
    Then I should see "Files found: 1"
    And I should not see "Invalid path"

    When I set the field "Path to check" to "index2.php"
    And I press "Check code"
    Then I should see "Invalid path index2.php"
    And I should not see "Files found: 1"

    When I set the field "Path to check" to "local/codechecker/version.php"
    And I set the field "Exclude" to "*/tests/fixtures/*"
    And I press "Check code"
    Then I should see "Well done!"
    And I should not see "Invalid path"

    When I set the field "Path to check" to "local/codechecker/moodle/tests/fixtures"
    And I set the field "Exclude" to "*/tests/fixtures/*"
    And I press "Check code"
    Then I should see "Files found: 0"
    And I should not see "Invalid path"

    When I set the field "Path to check" to "local/codechecker/tests/"
    And I set the field "Exclude" to "*/tests/fixtures/*"
    And I press "Check code"
    Then I should see "local_codechecker_testcase.php"
    And I should see "Files found: 1"
    And I should see "Well done!"
    And I should not see "Invalid path"

    When I set the field "Path to check" to "admin/index.php"
    And I press "Check code"
    Then I should see "Files found: 1"
    And I should see "Total:"
    And I should see "Expected 1 space before"
    And I should see "Inline comments must start"
    And I should not see "Well done!"

  Scenario: Verify that specified exclusions are performed
    Given I log in as "admin"
    And I navigate to "Development > Code checker" in site administration

    When I set the field "Path to check" to "local/codechecker/moodle/tests"
    And I set the field "Exclude" to "*/tests/fixtures/*"
    And I press "Check code"
    Then I should see "Files found: 1"
    And I should see "moodlestandard_test.php"
    And I should not see "Invalid path"

    When I set the field "Path to check" to "local/codechecker/moodle/tests/"
    And I set the field "Exclude" to "*PHPC*, *moodle_*"
    And I press "Check code"
    Then I should see "Files found: 5"
    And I should see "Line 1 of the opening comment"
    And I should see "Inline comments must end"
    And I should not see "phpcompat"

    When I set the field "Path to check" to "local/codechecker/moodle/tests/"
    And I set the field "Exclude" to "*moodle_*"
    And I press "Check code"
    Then I should see "Files found: 7"
    And I should see "phpcompat"
    And I should not see "moodle_php"

  # We use the @javascript tag here because of MDL-53083, causing non-javascript to fail unchecking checkboxes
  @javascript
  Scenario: Verify that the warnings toogle has effect
    Given I log in as "admin"
    And I navigate to "Development > Code checker" in site administration
    And I set the field "Path to check" to "local/codechecker/moodle/tests/fixtures/squiz_php_commentedoutcode.php"
    And I set the field "Exclude" to "dont_exclude_anything"
    # Warnings enabled
    And I set the field "Include warnings" to "1"
    When I press "Check code"
    Then I should see "Inline comments must start"
    And I should see "is this commented out code"
    And I should not see "0 warning(s)"
    # Warnings disabled
    And I set the field "Include warnings" to ""
    And I press "Check code"
    And I should see "0 warning(s)"
    And I should not see "Inline comments must start"
    And I should not see "is this commented out code"
    And I log out
