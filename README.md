It assumes the schemes are in `&packpath/pack/*/opt/` and it
tracks previously used schemes to avoid repetition.

To manually select another random scheme use `call
luaeval("require('random-colors')()")`, e.g. `command!
RandomColors call luaeval("require('random-colors')()")`.

Writing in [Fennel][fennel] and compiled to Lua with the help of
[Aniseed][aniseed].

[aniseed]: https://github.com/Olical/aniseed
[fennel]: https://fennel-lang.org
