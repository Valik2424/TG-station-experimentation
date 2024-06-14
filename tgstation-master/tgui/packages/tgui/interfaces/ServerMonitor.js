import { useBackend, useLocalState } from '../backend';
import {
  Section,
  Stack,
  Input,
  Button,
  Table,
  LabeledList,
  Flex,
  Divider,
  NoticeBox,
} from '../components';
import { Window } from '../layouts';

const PacketInfo = (props, context) => {
  const { act, data } = useBackend(context);
  const { packet } = props;
  return (
    <Stack.Item>
      <Flex justify="space-between">
        <Flex.Item align="left">{packet.name}</Flex.Item>
        <Flex.Item align="right">
          <Button
            icon="trash"
            color="red"
            onClick={() => act('delete_packet', { ref: packet.ref })}
          />
        </Flex.Item>
      </Flex>
      <LabeledList>
        <LabeledList.Item label="Тип Данных">{packet.type}</LabeledList.Item>
        <LabeledList.Item label="Источник">
          {packet.source + (packet.job ? ' (' + packet.job + ')' : '')}
        </LabeledList.Item>
        <LabeledList.Item label="Категория">{packet.race}</LabeledList.Item>
        <LabeledList.Item label="Содержимое">{packet.message}</LabeledList.Item>
        <LabeledList.Item label="Язык">{packet.language}</LabeledList.Item>
      </LabeledList>
      <Divider />
    </Stack.Item>
  );
};

const ServerScreen = (props, context) => {
  const { act, data } = useBackend(context);
  const { network, server } = data;
  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section
          title="Информация"
          buttons={
            <Button
              content="Главное меню"
              icon="home"
              onClick={() => act('return_home')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="Сеть">{network}</LabeledList.Item>
            <LabeledList.Item label="Сервер">{server.name}</LabeledList.Item>
            <LabeledList.Item label="Общее число записанных данных">
              {server.traffic >= 1024
                ? server.traffic / 1024 + ' TB'
                : server.traffic + ' GB'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable title="Сохранённые пакеты данных">
          <Stack vertical>
            {server.packets?.map((p) => (
              <PacketInfo key={p.ref} packet={p} />
            ))}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const MainScreen = (props, context) => {
  const { act, data } = useBackend(context);
  const { servers, network } = data;
  const [networkId, setNetworkId] = useLocalState(
    context,
    'networkId',
    network
  );

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section>
          <Input
            value={networkId}
            onInput={(e, value) => setNetworkId(value)}
            placeholder="ID сети"
          />
          <Button
            content="Scan"
            onClick={() => act('scan_network', { network_id: networkId })}
          />
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section
          fill
          scrollable
          title="Найденные телекоммуникационные сервера"
          buttons={
            <Button
              content="Сброс буфера"
              icon="trash"
              color="red"
              disabled={servers.length === 0}
              onClick={() => act('clear_buffer')}
            />
          }
        >
          <Table>
            <Table.Row header>
              <Table.Cell>Адрес</Table.Cell>
              <Table.Cell>ID</Table.Cell>
              <Table.Cell>Название</Table.Cell>
            </Table.Row>
            {servers?.map((s) => (
              <Table.Row key={s.ref}>
                <Table.Cell>{s.ref}</Table.Cell>
                <Table.Cell>{s.id}</Table.Cell>
                <Table.Cell>
                  <Button
                    content={s.name}
                    onClick={() => act('view_server', { server: s.ref })}
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

export const ServerMonitor = (props, context) => {
  const { act, data } = useBackend(context);
  const { screen, error } = data;
  return (
    <Window width={575} height={400}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            {error !== '' && <NoticeBox>{error}</NoticeBox>}
          </Stack.Item>
          <Stack.Item grow>
            {(screen === 0 && <MainScreen />) ||
              (screen === 1 && <ServerScreen />)}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
