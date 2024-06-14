import { useBackend, useLocalState } from '../backend';
import { BlockQuote, Box, Button, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';
import { multiline } from 'common/string';
import { paginate, range } from 'common/collections';

type Entry = {
  name: string;
  infuse_mob_name: string;
  desc: string;
  threshold_desc: string;
  qualities: string[];
  tier: number;
};

type DnaInfuserData = {
  entries: Entry[];
};

type BookPosition = {
  chapter: number;
  pageInChapter: number;
};

type TierData = {
  desc: string;
  icon: string;
  name: string;
};

const PAGE_HEIGHT = 30;

const TIER2TIERDATA: TierData[] = [
  {
    name: 'Малый мутант',
    desc: multiline`
      Малые мутанты обычно имеют меньший список потенциальных мутаций
      и не имеют бонусов за инфузию многих органов.
      Здесь находятся обычные виды, косметика и тому подобное. Всегда доступны!
    `,
    icon: 'circle-o',
  },
  {
    name: 'Обычный мутант',
    desc: multiline`
      Обычные мутанты имеют бонусы за инфузию ДНК в себя и достаточно часто
      встречаются во время смены. Всегда доступны!
    `,
    icon: 'circle-half-stroke',
  },
  {
    name: 'Большой мутант',
    desc: multiline`
      Большие мутанты имеют более сильные плюсы и минусы вместе с бонусом,
      и их труднее найти во время смены. Должны быть разблокированы,
      сначала разблокировав бонус мутанта ДНК более низкого уровня.
    `,
    icon: 'circle',
  },
  {
    name: 'Аберрация',
    desc: multiline`
      Нам удалось получить более сильных мутантов из выращенных в воде особей,
      отныне называемых "Аберрациями". Мутации имеют либо сильную полезность, либо
      утилитарную цель, аномальные качества или смертоносные способности.
    `,
    icon: 'teeth',
  },
];

export const InfuserBook = (props, context) => {
  const { data, act } = useBackend<DnaInfuserData>(context);
  const { entries } = data;

  const [bookPosition, setBookPosition] = useLocalState<BookPosition>(
    context,
    'bookPosition',
    {
      chapter: 0,
      pageInChapter: 0,
    }
  );
  const { chapter, pageInChapter } = bookPosition;

  const paginatedEntries = paginateEntries(entries);

  let currentEntry = paginatedEntries[chapter][pageInChapter];

  const switchChapter = (newChapter) => {
    if (chapter === newChapter) {
      return;
    }
    setBookPosition({ chapter: newChapter, pageInChapter: 0 });
    act('play_flip_sound'); // just so we can play a sound fx on page turn
  };

  const setPage = (newPage) => {
    const newBookPosition: BookPosition = { ...bookPosition };
    if (newPage < 0) {
      if (newBookPosition.chapter === 0) {
        return;
      }
      newBookPosition.chapter = chapter - 1;
      newBookPosition.pageInChapter = paginatedEntries[chapter - 1].length - 1;
      if (newBookPosition.pageInChapter < 0) {
        newBookPosition.pageInChapter = 0;
      }
    } else if (newPage > paginatedEntries[chapter].length - 1) {
      if (newBookPosition.chapter === 3) {
        return;
      } else {
        newBookPosition.pageInChapter = 0;
        newBookPosition.chapter = chapter + 1;
      }
    } else {
      newBookPosition.pageInChapter = newPage;
    }
    setBookPosition(newBookPosition);
    act('play_flip_sound'); // just so we can play a sound fx on page turn
  };

  const tabs = [
    'Вступление',
    'Тир 0 - Малые мутанты',
    'Тир 1 - Обычные мутанты',
    'Тир 2 - Большие мутанты',
    'Тир 3 - Аберрации - ЗАКРЫТО',
  ];

  const paginatedTabs = paginate(tabs, 3);

  const restrictedNext = chapter === 3 && pageInChapter === 0;

  return (
    <Window title="Инструкция к рекомбинатору" width={620} height={520}>
      <Window.Content>
        <Stack vertical>
          <Stack.Item mb={-1}>
            {paginatedTabs.map((tabRow, i) => (
              <Tabs height="30px" mb="0px" fill fluid key={i}>
                {tabRow.map((tab) => {
                  const tabIndex = tabs.indexOf(tab);
                  const tabIcon = TIER2TIERDATA[tabIndex - 1]
                    ? TIER2TIERDATA[tabIndex - 1].icon
                    : 'info';
                  return (
                    <Tabs.Tab
                      icon={tabIcon}
                      key={tabIndex}
                      selected={chapter === tabIndex}
                      onClick={
                        tabIndex === 4 ? null : () => switchChapter(tabIndex)
                      }
                    >
                      <Box color={tabIndex === 4 && 'red'}>{tab}</Box>
                    </Tabs.Tab>
                  );
                })}
              </Tabs>
            ))}
          </Stack.Item>
          <Stack.Item>
            {chapter === 0 ? (
              <InfuserInstructions />
            ) : (
              <InfuserEntry entry={currentEntry} />
            )}
          </Stack.Item>
          <Stack.Item textAlign="center">
            <Stack fontSize="18px" fill>
              <Stack.Item grow={2}>
                <Button onClick={() => setPage(pageInChapter - 1)} fluid>
                  Пред.
                </Button>
              </Stack.Item>
              <Stack.Item grow={1}>
                <Section fitted fill pt="3px">
                  Страница {pageInChapter + 1}/
                  {paginatedEntries[chapter].length + (chapter === 0 ? 1 : 0)}
                </Section>
              </Stack.Item>
              <Stack.Item grow={2}>
                <Button
                  color={restrictedNext && 'black'}
                  onClick={() => setPage(pageInChapter + 1)}
                  fluid
                >
                  {restrictedNext ? 'RESTRICTED' : 'След.'}
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const InfuserInstructions = (props, context) => {
  return (
    <Section title="Инструкция" height={PAGE_HEIGHT}>
      <Stack vertical>
        <Stack.Item fontSize="16px">Как это работает?</Stack.Item>
        <Stack.Item color="label">
          Инфузия ДНК - это практика интеграции ДНК мертвого существа в вас
          самих, мутации одного из ваших органов в генетическую кашицу, которая
          находится где-то между вашей и этого существа. Хотя это еще больше
          отдаляет вас от того, чтобы быть человеком, и дает множество...
          неприятных побочных эффектов, это также предоставляет новые
          возможности..{' '}
          <b>
            Прежде всего, вы должны понимать, что генные мутанты обычно очень
            хороши в определенных вещах, особенно с их пороговыми бонусами.
          </b>
        </Stack.Item>
        <Stack.Item fontSize="16px">
          Я готов! Как это всё таки работает?
        </Stack.Item>
        <Stack.Item color="label">
          <li>
            <ul>
              1. Поместите мёртвое существо в рекомбинатор. Из него вы будете
              брать ДНК.
            </ul>
            <ul>2. Войдите в машину, как в манипулятор ДНК.</ul>
            <ul>3. Попросите кого-нибудь активировать машину снаружи.</ul>
          </li>
          <Box mt="10px" inline color="white">
            Готово! Обратите внимание, что существо будет уничтожено в процессе
            инфузии ДНК.
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

type InfuserEntryProps = {
  entry: Entry;
};

const InfuserEntry = (props: InfuserEntryProps, context) => {
  const { entry } = props;

  const tierData = TIER2TIERDATA[entry.tier];

  return (
    <Section
      fill
      title={entry.name}
      height={PAGE_HEIGHT}
      buttons={
        <Button tooltip={tierData.desc} icon={tierData.icon}>
          {tierData.name}
        </Button>
      }
    >
      <Stack vertical fill>
        <Stack.Item>
          <BlockQuote>
            {entry.desc}{' '}
            {entry.threshold_desc && (
              <>
                {' '}
                Если субъект инфузирует достаточно ДНК, {entry.threshold_desc}
              </>
            )}
          </BlockQuote>
        </Stack.Item>
        <Stack.Item grow>
          Qualities:
          {entry.qualities.map((quality) => {
            return (
              <Box color="label" key={quality}>
                - {quality}
              </Box>
            );
          })}
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item>
          Создаётся путём добавления ДНК{' '}
          <Box inline color={entry.name === 'Отклонено' ? 'red' : 'green'}>
            {entry.infuse_mob_name}
          </Box>{' '}
          к субъекту.
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const paginateEntries = (collection: Entry[]): Entry[][] => {
  const pages: Entry[][] = [];
  let maxTier = -1;
  // find highest tier entry
  collection.forEach((entry) => {
    if (entry.tier > maxTier) {
      maxTier = entry.tier;
    }
  });
  // negative 1 to account for introduction, which has no entries
  let tier = -1;
  for (let _ in range(tier, maxTier + 1)) {
    pages.push(collection.filter((entry) => entry.tier === tier));
    tier++;
  }
  return pages;
};
