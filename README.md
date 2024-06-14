## /tg/station codebase

[![Статус билда](https://github.com/frosty-dev/tgstation/workflows/CI%20Suite/badge.svg)](https://github.com/frosty-dev/tgstation/actions?query=workflow%3A%22CI+Suite%22)
[![Процент открытых ишшуев](https://isitmaintained.com/badge/open/frosty-dev/tgstation.svg)](https://isitmaintained.com/project/frosty-dev/tgstation "Процент открытых ишшуев")
[![Среднее время фикса](https://isitmaintained.com/badge/resolution/frosty-dev/tgstation.svg)](https://isitmaintained.com/project/frosty-dev/tgstation "Среднее время фикса")

[![resentment](.github/images/badges/built-with-resentment.svg)](.github/images/comics/131-bug-free.png) [![technical debt](.github/images/badges/contains-technical-debt.svg)](.github/images/comics/106-tech-debt-modified.png) [![forinfinityandbyond](.github/images/badges/made-in-byond.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)

| Website                   | Link                                           |
|---------------------------|------------------------------------------------|
| Website                   | [https://www.tgstation13.org](https://www.tgstation13.org)              |
| Code                      | [https://github.com/frosty-dev/tgstation](https://github.com/frosty-dev/tgstation)    |
| Wiki                      | [https://wiki.station13.ru/](https://wiki.station13.ru/)   |
| Codedocs                  | [https://codedocs.tgstation13.org/](https://codedocs.tgstation13.org/)       |
| Discord       | [https://discord.station13.ru/](https://discord.station13.ru/) |

This is the codebase for the /tg/station flavoured fork of SpaceStation 13.

Space Station 13 is a paranoia-laden round-based roleplaying game set against the backdrop of a nonsensical, metal death trap masquerading as a space station, with charming spritework designed to represent the sci-fi setting and its dangerous undertones. Have fun, and survive!

## DOWNLOADING

[Downloading](.github/guides/DOWNLOADING.md)

[Running a server](.github/guides/RUNNING_A_SERVER.md)

[Maps and Away Missions](.github/guides/MAPS_AND_AWAY_MISSIONS.md)

## :exclamation: How to compile :exclamation:

On **2021-01-04** we have changed the way to compile the codebase.

**The quick way**. Find `bin/server.cmd` in this folder and double click it to automatically build and host the server on port 1337.

**The long way**. Find `bin/build.cmd` in this folder, and double click it to initiate the build. It consists of multiple steps and might take around 1-5 minutes to compile. If it closes, it means it has finished its job. You can then [setup the server](.github/guides/RUNNING_A_SERVER.md) normally by opening `tgstation.dmb` in DreamDaemon.

**Building tgstation in DreamMaker directly is now deprecated and might produce errors**, such as `'tgui.bundle.js': cannot find file`.

**[How to compile in VSCode and other build options](tools/build/README.md).**

## Contributors

[Guides for Contributors](.github/CONTRIBUTING.md)

[/tg/station HACKMD account](https://hackmd.io/@tgstation) - Design documentation here

[Interested in some starting lore?](https://github.com/tgstation/common_core)

## LICENSE

Весь код после [коммита 333c566b88108de218d882840e61928a9b759d8f на 2014/31/12 в 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) лицензирован под [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

Весь код до [коммита 333c566b88108de218d882840e61928a9b759d8f на 2014/31/12 в 4:38 PM PST](https://github.com/tgstation/tgstation/commit/333c566b88108de218d882840e61928a9b759d8f) лицензирован под [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Включая папку tools, но только если их readme не сообщает обратное)

Смотрите LICENSE и GPLv3.txt за подробностями.

TGS DMAPI API лицензирован как подпроект под MIT лицензией.

Посмотрите в самый низ [code/__DEFINES/tgs.dm](./code/__DEFINES/tgs.dm) и [code/modules/tgs/LICENSE](./code/modules/tgs/LICENSE), чтобы найти MIT лицензию.

Все ассеты включая иконки и звуки лицензированы под [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/), если это не обозначено где-то ещё.

Опубликованный русскоязычный текст в коде находится под лицензией [Creative Commons 4.0 BY-NC-SA license](https://creativecommons.org/licenses/by-nc-sa/4.0/), если это не обозначено где-то ещё. Это подразумевает под собой то, что использование нашего перевода где-либо ещё требует наличие данной авторской лицензии (включая всех авторов, которые когда-либо вносили правки) и отметки о том, что было изменено.
