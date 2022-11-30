# nvim-altcaps

Transform words to alternating letter casing in order to convey sarcasm or
mockery. For example, convert `I respect the authorities` to `i ReSpEcT tHe
AuThOriTiEs`.

`nvim-altcaps` provides an operator that can be used over any text object. It is
correct by default for English text, as defined by subject-matter expert
Marc-Anthony Chouillard: the letter 'i' is never capitalized, whereas the letter
'L' is always capitalized. Note the difference with the [competing Emacs
package](https://protesilaos.com/emacs/altcaps), which once more aSsERtS tHe
SuPeRiORiTy Of ThE nEoViM eCoSyStEm OvER tHaT oF eMaCs.

`nvim-altcaps` also supports Unicode by default, although rules for non-English
languages are not setup by default. See Configuration below.

## Usage

`require('altcaps').operator` is an operator that transitions Neovim from normal
mode to operator-pending mode, and operates over visual selections. Whatever key
you assign to it will behave like the default `d`, `y` or `c` keys, except that
it will transform the text instead of deleting/yanking/changing it.

Example binding:

```lua
vim.keymap.set({'n', 'v'}, '<Leader>a', require('altcaps').operator, { expr = true })
```

## Configuration

`nvim-altcaps` supports forcing some letters to always be uppercased or
lowercased by calling the (otherwise not required) `setup` function.

For example, using the following configuration:

```lua
local altcaps = require('altcaps')
altcaps.setup({
    l = altcaps.upper,
    r = altcaps.upper,
    i = altcaps.lower,
    î = altcaps.lower,
})
```

`Îles où l'on ne prendra jamais terre` would be converted to `îLeS oÙ L'On Ne
PREnDRA jAmAiS tERRe`.

## Acknowledgments

Thanks to Protesilaos Stavrou for writing
[`altcaps.el`](https://protesilaos.com/emacs/altcaps), to which `nvim-altcaps`
is very much a playful reaction. They say imitation is the sincerest form of
flattery, so all resemblances are intentional and meant as marks of respect
rather than mockery.
