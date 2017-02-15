# Setup


## Requirements

* The app requires ruby "2.3.1"
* The app has a single gem requirement via its `Gemfile` - the `thor` gem. `bundle install` to install the gem. (Thor is used to make the app as a commandline program.)


## Running the app

From the root path of this application, run this command to see the output:

> `./bin/galaxy decipher data/input1.txt`

where,

* `./bin/galaxy` is the ruby executable. Make sure this file is executable. (`chmod +x bin/galaxy`)

* `decipher` is the command name

* `data/input1.txt` is the argument to the above command. It is present in the `data` folder. This txt file contains the input strings to the program. There's also another test input file: `data/input2.txt` that can be passed as arg.


## Output

On running this command, the output will be displayed in the screen using stdout.

For `data/input1.txt`, the output will be:

```
pish tegj glob glob is 42
glob prok Silver is 68 Credits
glob prok Gold is 57800 Credits
glob prok Iron is 782 Credits
I have no idea what you are talking about
```

For `data/input2.txt`, the output will be:

```
pish tegj glob glob is 42
glob prok Silver is 68 Credits
I have no idea what you are talking about
glob prok Iron is 782 Credits
I have no idea what you are talking about
```

## Running Tests
* The `test/galaxy/parser_spec.rb` describes the `Parser` class. Its tests can be run like so: `ruby test/galaxy/parser_spec.rb`. The output of running this command in my system is this:

```
Run options: --seed 48318

# Running:

..

Finished in 0.001635s, 1223.4511 runs/s, 5505.5300 assertions/s.

2 runs, 9 assertions, 0 failures, 0 errors, 0 skips
```

* The `test/galaxy/numeral_spec.rb` describes the `Numeral` class. Its tests can be run like so: `ruby test/galaxy/numeral_spec.rb`. The output of running this command in my system is this:

```
Run options: --seed 19525

# Running:

.....

Finished in 0.001870s, 2673.3479 runs/s, 18713.4355 assertions/s.

5 runs, 35 assertions, 0 failures, 0 errors, 0 skips
```
