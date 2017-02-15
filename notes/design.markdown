# Design


The app is developed as a commandline ruby application. The main executable is the `bin/galaxy` which responds to a command `decipher` that takes as argument a string that represents the relative path to the input text file. The output is just a series of strings displayed to the STDOUT.


## Modular Components
All classes and modules for this app are wrapped in the main `Galaxy` module.

The executable file `bin/galaxy` calls the `process` thor command defined in the `Galaxy::CLI` thor class.

This thor just acts as a proxy to the PORO `Galaxy::Main` class whose `process!` method orchestrates the main functionality of the app.

It uses the `Galaxy::Parser` class to read the input file and extract the tokens as meaningful components. It then feeds this processed, parsed input to the `Galaxy::Numeral` class.

The `Galaxy::Numeral` is the main class. It represents the galactic numerals. It provides helper methods to convert galactic code to roman, and from roman to arabic. It defines parser methods that extract commodity values from input strings, and calculate the price for commodities represented in galactic counts.

The application has logging support via its memoized `Galaxy.logger` method. It writes to a log file present in the `log` dir in the root path.


## Tests
The Parser and Numeral classes have test coverage via minitest.

The test files are present in `test` dir. Instructions to run the tests are present in t the `setup.markdown` doc.


## Notes
The `notes` dir has these 2 important docs:

* design.markdown - this doc that details the app design
* setup.markdown - details how to setup and run this app, and where to see the output.

It also has these docs that are not that important:

* problem_description.markdown - the whole problem description from the email
* manual_solution.markdown - my notes while attempting to solve the test input given in the email.
