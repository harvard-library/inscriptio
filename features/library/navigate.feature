Feature: a library has many floors

A library has many floors.

Scenario: A library has many floors
  Given a library with an id of 1
  Then the library should have a floor named "Floor 1"
