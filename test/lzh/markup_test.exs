defmodule Lzh.MarkupTest do
  use ExUnit.Case, async: true

  import Lzh.Markup

  describe "markdown → html" do
    test "html in markdown" do
      assert to_html("<script>alert('XSS');</script>") ==
               "&lt;script&gt;alert(&#39;XSS&#39;);&lt;/script&gt;"
    end

    test "inline links" do
      # https://daringfireball.net/projects/markdown/syntax#link
      assert to_html("[This link](http://example.net/) has no title attribute.") ==
               "<a href=\"http://example.net/\" target=\"_blank\" class=\"underline\">This link</a> has no title attribute."

      # internationalised domain names
      assert to_html("[Tübingen](http://tübingen.berlin/)") ==
               "<a href=\"http://tübingen.berlin/\" target=\"_blank\" class=\"underline\">Tübingen</a>"

      assert to_html("[Нещо такова](http://пример.бг/?)") ==
               "<a href=\"http://пример.бг/?\" target=\"_blank\" class=\"underline\">Нещо такова</a>"
    end

    # source: https://daringfireball.net/projects/markdown/syntax#em
    test "emphasis — daring fireball" do
      assert to_html("*single asterisks*") == "<em>single asterisks</em>"
      assert to_html("_single underscores_") == "<em>single underscores</em>"
      assert to_html("**double asterisks**") == "<strong>double asterisks</strong>"
      assert to_html("__double underscores__") == "<strong>double underscores</strong>"

      assert to_html("un*frigging*believable") == "un<em>frigging</em>believable"

      assert to_html("\\*this text is surrounded by literal asterisks\\*") ==
               "\\*this text is surrounded by literal asterisks\\*"
    end

    # source: the inline emphasis tests of https://pypi.org/project/Markdown/
    test "emphasis — python markdown" do
      assert to_html("*") == "*"
      assert to_html("_") == "_"

      assert to_html("foo * bar") == "foo * bar"
      assert to_html("foo _ bar") == "foo _ bar"

      assert to_html("foo * bar * baz") == "foo * bar * baz"
      assert to_html("foo _ bar _ baz") == "foo _ bar _ baz"

      # added the <br>'s to the original assertion
      assert to_html("foo\n* bar *\nbaz") == "foo<br>* bar *<br>baz"
      assert to_html("foo\n_ bar _\nbaz") == "foo<br>_ bar _<br>baz"

      assert to_html("foo * bar *") == "foo * bar *"
      assert to_html("_ bar _") == "_ bar _"

      assert to_html("This is text **bold *italic bold*** with more text") ==
               "This is text <strong>bold <em>italic bold</em></strong> with more text"

      assert to_html("This is text **bold*italic bold*** with more text") ==
               "This is text <strong>bold<em>italic bold</em></strong> with more text"

      assert to_html("This is text __bold _italic bold___ with more text") ==
               "This is text <strong>bold <em>italic bold</em></strong> with more text"

      # added the <em>'s and <strong>'s to the original assertion
      assert to_html("This is text __bold_italic bold___ with more text") ==
               "This is text <strong>bold<em>italic bold</em></strong> with more text"

      assert to_html("This text is **bold *italic* *italic* bold**") ==
               "This text is <strong>bold <em>italic</em> <em>italic</em> bold</strong>"

      assert to_html("traced ***along*** bla **blocked** if other ***or***") ==
               "traced <strong><em>along</em></strong> bla <strong>blocked</strong> if other <strong><em>or</em></strong>"

      assert to_html("on the **1-4 row** of the AP Combat Table ***and*** receive") ==
               "on the <strong>1-4 row</strong> of the AP Combat Table <strong><em>and</em></strong> receive"
    end

    # even more emphasis tests
    test "emphasis — more" do
      assert to_html("* no *") == "* no *"
      assert to_html("_ no_") == "_ no_"

      assert to_html("**no **") == "**no **"
      assert to_html("__ no __") == "__ no __"

      assert to_html("***bold and italic***") ==
               "<strong><em>bold and italic</em></strong>"

      # the closing tags are the wrong way round
      # this is also how the original markdown implementation does it
      # source: https://daringfireball.net/projects/markdown/dingus
      assert to_html("*italic **italic and bold***") ==
               "<em>italic <strong>italic and bold</em></strong>"

      assert to_html("**_italic and bold_ bold**") ==
               "<strong><em>italic and bold</em> bold</strong>"
    end
  end
end
