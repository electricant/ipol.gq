# This is an example page

Paragraphs are separated by a blank line.

2nd paragraph. *Italic*, **bold**, and `monospace`.
\*this text is surrounded by literal asterisks\*

Itemized lists look like:

  * this one
  * that one
  * the other one

To make lists look nice, you can wrap items with hanging indents:

*   Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
    Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,
    viverra nec, fringilla in, laoreet vitae, risus.
*   Donec sit amet nisl. Aliquam semper ipsum sit amet velit.
    Suspendisse id sem consectetuer libero luctus adipiscing.

Note that --- not considering the asterisk --- the actual text
content starts at 4-columns in.

> Block quotes are
> written like so.
>
> They can span multiple paragraphs,
> if you like.

Use 3 dashes for an em-dash. Use 2 dashes for ranges (ex., "it's all
in chapters 12--14"). Three dots ... will be converted to an ellipsis.
Unicode is supported. ☺

An h2 header<a name="h2_header"></a>
------------

Here's a numbered list:

 1. first item
 2. second item
 3. third item

Note again how the actual text starts at 4 columns in (4 characters
from the left side). Here's a code sample:

    # Let me re-iterate ...
    for i in 1 .. 10
    { do-something(i) }

As you probably guessed, indented 4 spaces.
    define foobar() {
        print "Welcome to flavor country!";
    }

### An h3 header

Now a nested list:

 1. First, get these ingredients:

      * carrots
      * celery
      * lentils

 2. Boil some water.

 3. Dump everything in the pot and follow this algorithm:

        find wooden spoon
        uncover pot
        stir
        cover pot
        balance wooden spoon precariously on pot handle
        wait 10 minutes
        goto first step (or shut off burner when done)

    Do not bump wooden spoon or it will fall.

Notice again how text always lines up on 4-space indents (including
that last line which continues item 3 above).

Here's a link to [a website](http://foo.bar), to a [local doc](local-doc.html),
and to a [section heading in the current doc](#h2_header).
Here's a footnote [^1][].

[^1]: http://example.com

A horizontal rule follows.

***

and images can be specified like so:

![example image](/images/photo.jpg "An exemplary image")

Note that you can backslash-escape any punctuation characters
which you wish to be displayed literally, ex.: \`foo\`, \*bar\*, etc.

To add inline html:

This is a regular paragraph.

<table>
    <tr>
        <td>Foo</td>
        <td>Bar</td>
        <td>Baz</td>
    </tr>
</table>

This is another regular paragraph.
