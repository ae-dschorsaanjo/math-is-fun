# Math is Fun!

Math is Fun! is the spiritual successor of [game.py](https://github.com/ae-dschorsaanjo/game.py) written in Free Pascal.

# How to play?

The game expects a terminal/command line with a size of at least 80x24 characters. After starting the program, it is recommended to run through the help menu and adjust the settings before playing.

# How to compile?

The game only needs Free Pascal (3.0+). It should compile without any further dependencies.

Here's a sample command for compiling on Windows: `fpc mathisfun.pas -obuild/mathisfun.exe & delp build`

# Future plans

- Fix statistics horizontals formatting as shown in terminal.
- Refactor code:
    - Write/rewrite comments,
    - Review code and make it more readable if needed.
- Enforce proper terminal/command line sizing.
- Increment version number up to v0.3 after code refactor and output text formatting are done. Use v0.2* versions until then.

# Copyright

This project's used the Modified BSD License (a.k.a. 3-clause BSD License).
