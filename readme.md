Fareoffice Language
===================

Used to save multiple translations of a text in one mysql column.

This is very useful if you have an existing database model which stores texts
that you in a later stage want to translate to different languages. With this
plugin module, you will not need to redesign your database model. It's also
useful if you don't want a "cluttered" database model where "every" table
has a relation to your translation tables.

The texts are loaded from and saved to the database with two UDF functions,
getLanguage and setLanguage.

    INSERT INTO foLanguageTest
        (id, description)
    VALUES
        (1, setLanguage(NULL, "Sverige", "SE_", ""));

    UPDATE
        foLanguageTest
    SET
        description = setLanguage(description, "England", "UK_", "FI_")
    WHERE
        id = 1;

    SELECT
        getLanguage(description, "FI_", "UK_", 1)
    FROM
        foLanguageTest';


REQUIRMENTS
===========

* This module are only tested on centos 6.3.
* We assume that a short is 2 bytes and a long is 8 bytes.
* Mysql needs to be installed. We are using the version that is comming with
  centos 6.3.


COMPILE AND INSTALL
===================

Install all yum packages required to build the foLanguage module.

    make requirements

Compile the module. This will also run all unit tests and valgrind to find any
memory leeks.

    make

Install the plugin into mysql plugin folder. More unit tests will be executed
when the module is installed.

    make install

FOLDERS
=======

    bin         - Executable scipts.
    build       - Where all build files will be generated.
    src         - All source code


DOCUMENTATION
=============

Format of the fo_language_column.
------------------------------

The fo_language_column is saved in a "blob" column in mysql. The format of the
information is saved in the following struct.

HEADER
INDEX*n
DATA*n

HEADER
------

	NAME             | SIZE   | Description
	-----------------------------------------------------------------------------
	validation_code  | word   | Defines that this is a fo_language_column. IE: 655536.
	version          | byte   | Current version of the language struct format.
	num_of_Language  | word   | Number of different languages saved in the column.
	index_pos        | dword  | Position where the index are saved.
	data_pos         | dword  | Position where the texts are saved.
	default_language | word   | Two character representation of default language.

INDEX
-----

The index saved in a mysql column is repeated for each language. The first
language in the index part are the default language.

    NAME     | SIZE               | Description
    ------------------------------------------------------------------------------------
    language | foLDC_LANGUAGESIZE | Language code represented by X number of character.
    startpos | dword              | Position where the text for this language is started.
             |                    | 0 is datapos. Excluding [LANG TAG.
    length   | dword              | Length of the text. Excluding [LANG TAG.


DATA
-----

    NAME | SIZE | Description
    ----------------------------------------------------------
    data | blob | The language tag Ie [LANG=SE_]Sverige[/LANG]


EXAMPLES
========

The file test/test.py demonstrates the functionality of foLanguage.
At the same time as it tests that the functions works as they should on the
mysql server.

