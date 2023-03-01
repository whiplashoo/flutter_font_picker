flutter_fonts_picker package `constants.dart` file generator.
--------------------------------------------------------------

A)  To generate new `lib\src\constants.dart` file containing information for the latest generation of google fonts go to [https://developers.google.com/fonts/docs/developer_api](https://developers.google.com/fonts/docs/developer_api) and click the blue 'EXECUTE' button on the right and then copy the JSON output that appears and create a file in this directory and paste this JSON here and save the file.
Alternately you can aquire your own private google fonts API key and supply that on the command line of the `update_constants.dart` program.  These keys are private so each user must generate their own if this is the route you wish to take.

B)  This Step IS OPTIONAL.  A current complete font list for the current google_fonts package will AUTOMATICALLY be retrieved from `https://raw.githubusercontent.com/material-foundation/flutter-packages/main/packages/google_fonts/generator/families_supported` .

OPTIONALLY A list of the fonts included in the current googlefonts package specified in the root pubspec.yaml CAN OPTIONALLY be captured and (end edited if desired) and saved before running the `update_constants.dart` generator.
This is done by:

  1) Updating the root pubspec.yaml to have `google_fonts:` package reference the current version.
  2) Going to the example\ directory and running the \example\lib\display_googlefonts_fontlist.dart program.
  3) Once the program is running copy the list of font names by selecting all of the text and copying to clipboard.
  4) Open a new file within the generator directory (ie. googlefonts_X.Y.Z_fontlist.txt (where 'X.Y.Z' is the version of google_fonts specified within the pubspec.yaml (such as '4.0.3')).
  5) Optionally EDIT this font list to reduce the number of fonts
  5) Paste the list of fonts from the clipboard into this file and save the file.

C)  It is possible to pass the `--legacylanguages` (or `-l`)command line option to keep the previous versions list of languages.  There are quite a large list of languages now and the current version (as of 1.1.3) does not include most of these.

D)  Execute the `update_constants.dart` generator program.  This will out information of added/removed categories, languages and fonts from the previous `constants.dart` version.  It will write a NEW `constants.dart` file in the current directory.  This can then be manually compared with previous version (if desired) and then copied into the `\lib\src\constants\` directory to overwrite the previous version of `constants.dart`.

Examples of command lines to execute the generator program:

I) Using a local file for the google fonts JSON file (and automatically retrieving google_fonts font list from `https://raw.githubusercontent.com/material-foundation/flutter-packages/main/packages/google_fonts/generator/families_supported`):

```shell
cd generator
dart run update_constants.dart -i api_output_feb_22_23.json
```

II) Using local files for both the google fonts JSON file and the google_package font list:

```shell
cd generator
dart run update_constants.dart -g googlefonts_4.0.3_fontlist.txt -i api_output_feb_22_23.json
```

III) Using your private API key and a local file for the google_package font list:

```shell
cd generator
dart run update_constants.dart -g googlefonts_4.0.3_fontlist.txt --apikey YOUR_SECRET_API_KEY
```

VI) Display the help and command line usage instructions:

```shell
cd generator
dart run update_constants.dart -h
```

NOTE:  It is possible to limit the list of langauges to those of the previous version of constants.dart using the  `--legacylanguages` (or `-l`) command line option.

-----------------------------------------

When the generator is executed a list of all added and removed languages, categories and fonts from the previous constants.dart file will be displayed.  A file in the current directory called `constants.dart` will be created.

Example of entire process of creating new `constants.dart` file and replacing the old (assuming you have a YOUR_SECRET_API_KEY.)

```shell
cd generator
dart run update_constants.dart --apikey YOUR_SECRET_API_KEY
cp constants.dart ../lib/src/constants/constants.dart
```
