import { sortBy } from 'common/collections';
import { capitalize } from 'common/string';
import { useBackend, useLocalState } from '../backend';
import {
  Blink,
  Box,
  Button,
  Dimmer,
  Flex,
  Icon,
  Modal,
  Section,
  TextArea,
} from '../components';
import { StatusDisplayControls } from './common/StatusDisplayControls';
import { Window } from '../layouts';
import { sanitizeText } from '../sanitize';

const STATE_BUYING_SHUTTLE = 'buying_shuttle';
const STATE_CHANGING_STATUS = 'changing_status';
const STATE_MAIN = 'main';
const STATE_MESSAGES = 'messages';

// Used for whether or not you need to swipe to confirm an alert level change
const SWIPE_NEEDED = 'SWIPE_NEEDED';

const EMAG_SHUTTLE_NOTICE =
  'This shuttle is deemed significantly dangerous to the crew, and is only supplied by the Syndicate.';

const sortShuttles = sortBy(
  (shuttle) => !shuttle.emagOnly,
  (shuttle) => shuttle.initial_cost
);

const AlertButton = (props, context) => {
  const { act, data } = useBackend(context);
  const { alertLevelTick, canSetAlertLevel } = data;
  const { alertLevel, setShowAlertLevelConfirm } = props;

  const thisIsCurrent = data.alertLevel === alertLevel;

  return (
    <Button
      icon="exclamation-triangle"
      color={thisIsCurrent && 'good'}
      content={capitalize(alertLevel)}
      onClick={() => {
        if (thisIsCurrent) {
          return;
        }

        if (canSetAlertLevel === SWIPE_NEEDED) {
          setShowAlertLevelConfirm([alertLevel, alertLevelTick]);
        } else {
          act('changeSecurityLevel', {
            newSecurityLevel: alertLevel,
          });
        }
      }}
    />
  );
};

const MessageModal = (props, context) => {
  const { data } = useBackend(context);
  const { maxMessageLength } = data;

  const [input, setInput] = useLocalState(context, props.label, '');

  const longEnough =
    props.minLength === undefined || input.length >= props.minLength;

  return (
    <Modal>
      <Flex direction="column">
        <Flex.Item fontSize="16px" maxWidth="90vw" mb={1}>
          {props.label}:
        </Flex.Item>

        <Flex.Item mr={2} mb={1}>
          <TextArea
            fluid
            height="20vh"
            width="80vw"
            backgroundColor="black"
            textColor="white"
            onInput={(_, value) => {
              setInput(value.substring(0, maxMessageLength));
            }}
            value={input}
          />
        </Flex.Item>

        <Flex.Item>
          <Button
            icon={props.icon}
            content={props.buttonText}
            color="good"
            disabled={!longEnough}
            tooltip={!longEnough ? 'Придумайте причину получше.' : ''}
            tooltipPosition="right"
            onClick={() => {
              if (longEnough) {
                setInput('');
                props.onSubmit(input);
              }
            }}
          />

          <Button
            icon="times"
            content="Отмена"
            color="bad"
            onClick={props.onBack}
          />
        </Flex.Item>

        {!!props.notice && (
          <Flex.Item maxWidth="90vw">{props.notice}</Flex.Item>
        )}
      </Flex>
    </Modal>
  );
};

const NoConnectionModal = () => {
  return (
    <Dimmer>
      <Flex direction="column" textAlign="center" width="300px">
        <Flex.Item>
          <Icon color="red" name="wifi" size={10} />

          <Blink>
            <div
              style={{
                background: '#db2828',
                bottom: '60%',
                left: '25%',
                height: '10px',
                position: 'relative',
                transform: 'rotate(45deg)',
                width: '150px',
              }}
            />
          </Blink>
        </Flex.Item>

        <Flex.Item fontSize="16px">
          A connection to the station cannot be established.
        </Flex.Item>
      </Flex>
    </Dimmer>
  );
};

const PageBuyingShuttle = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Box>
      <Section>
        <Button
          icon="chevron-left"
          content="Назад"
          onClick={() => act('setState', { state: STATE_MAIN })}
        />
      </Section>

      <Section>
        Бюджет: <b>{data.budget.toLocaleString()}</b> кредитов
      </Section>

      {sortShuttles(data.shuttles).map((shuttle) => (
        <Section
          title={
            <span
              style={{
                display: 'inline-block',
                width: '70%',
              }}
            >
              {shuttle.name}
            </span>
          }
          key={shuttle.ref}
          buttons={
            <Button
              content={`${shuttle.creditCost.toLocaleString()} кредитов`}
              color={shuttle.emagOnly ? 'red' : 'default'}
              disabled={data.budget < shuttle.creditCost}
              onClick={() =>
                act('purchaseShuttle', {
                  shuttle: shuttle.ref,
                })
              }
              tooltip={
                data.budget < shuttle.creditCost
                  ? `Требуется ещё ${shuttle.creditCost - data.budget} кр.`
                  : shuttle.emagOnly
                  ? EMAG_SHUTTLE_NOTICE
                  : undefined
              }
              tooltipPosition="left"
            />
          }
        >
          <Box>{shuttle.description}</Box>
          <Box color="teal" fontSize="10px" italic>
            Число мест: {shuttle.occupancy_limit}
          </Box>
          <Box color="violet" fontSize="10px" bold>
            {shuttle.prerequisites ? (
              <b>Требования: {shuttle.prerequisites}</b>
            ) : null}
          </Box>
        </Section>
      ))}
    </Box>
  );
};

const PageChangingStatus = (props, context) => {
  const { act } = useBackend(context);

  return (
    <Box>
      <Section>
        <Button
          icon="chevron-left"
          content="Назад"
          onClick={() => act('setState', { state: STATE_MAIN })}
        />
      </Section>

      <StatusDisplayControls />
    </Box>
  );
};

const PageMain = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    alertLevel,
    alertLevelTick,
    aprilFools,
    callShuttleReasonMinLength,
    canBuyShuttles,
    canMakeAnnouncement,
    canMessageAssociates,
    canRecallShuttles,
    canRequestNuke,
    canSendToSectors,
    canSetAlertLevel,
    canToggleEmergencyAccess,
    emagged,
    syndicate,
    emergencyAccess,
    importantActionReady,
    sectors,
    shuttleCalled,
    shuttleCalledPreviously,
    shuttleCanEvacOrFailReason,
    shuttleLastCalled,
    shuttleRecallable,
  } = data;

  const [callingShuttle, setCallingShuttle] = useLocalState(
    context,
    'calling_shuttle',
    false
  );
  const [messagingAssociates, setMessagingAssociates] = useLocalState(
    context,
    'messaging_associates',
    false
  );
  const [messagingSector, setMessagingSector] = useLocalState(
    context,
    'messaing_sector',
    null
  );
  const [requestingNukeCodes, setRequestingNukeCodes] = useLocalState(
    context,
    'requesting_nuke_codes',
    false
  );

  const [
    [showAlertLevelConfirm, confirmingAlertLevelTick],
    setShowAlertLevelConfirm,
  ] = useLocalState(context, 'showConfirmPrompt', [null, null]);

  return (
    <Box>
      {!syndicate && (
        <Section title="Эвакуационный шаттл">
          {(!!shuttleCalled && (
            <Button.Confirm
              icon="space-shuttle"
              content="Отозвать шаттл"
              color="bad"
              disabled={!canRecallShuttles || !shuttleRecallable}
              tooltip={
                (canRecallShuttles &&
                  !shuttleRecallable &&
                  'Слишком поздно. Шаттл уже в пути.') ||
                'У Вас недостаточно привилегий.'
              }
              tooltipPosition="bottom-end"
              onClick={() => act('recallShuttle')}
            />
          )) || (
            <Button
              icon="space-shuttle"
              content="Вызвать эвакуационный шаттл"
              disabled={shuttleCanEvacOrFailReason !== 1}
              tooltip={
                shuttleCanEvacOrFailReason !== 1
                  ? shuttleCanEvacOrFailReason
                  : undefined
              }
              tooltipPosition="bottom-end"
              onClick={() => setCallingShuttle(true)}
            />
          )}
          {!!shuttleCalledPreviously &&
            ((shuttleLastCalled && (
              <Box>
                Последний раз шаттл был вызван: <b>{shuttleLastCalled}</b>
              </Box>
            )) || <Box>Невозможно определить последний вызов шаттла.</Box>)}
        </Section>
      )}

      {!!canSetAlertLevel && (
        <Section title="Уровень тревоги">
          <Flex justify="space-between">
            <Flex.Item>
              <Box>
                Текущий уровень: <b>{capitalize(alertLevel)}</b>
              </Box>
            </Flex.Item>

            <Flex.Item>
              <AlertButton
                alertLevel="green"
                showAlertLevelConfirm={showAlertLevelConfirm}
                setShowAlertLevelConfirm={setShowAlertLevelConfirm}
              />

              <AlertButton
                alertLevel="blue"
                showAlertLevelConfirm={showAlertLevelConfirm}
                setShowAlertLevelConfirm={setShowAlertLevelConfirm}
              />
            </Flex.Item>
          </Flex>
        </Section>
      )}

      <Section title="Функции">
        <Flex direction="column">
          {!!canMakeAnnouncement && (
            <Button
              icon="bullhorn"
              content="Создать срочное объявление"
              onClick={() => act('makePriorityAnnouncement')}
            />
          )}

          {!!canToggleEmergencyAccess && (
            <Button.Confirm
              icon="id-card-o"
              content={`${
                emergencyAccess ? 'Отключить' : 'Включить'
              } Экстренный доступ к техтоннелям`}
              color={emergencyAccess ? 'bad' : undefined}
              onClick={() => act('toggleEmergencyAccess')}
            />
          )}

          {!syndicate && (
            <Button
              icon="desktop"
              content="Настроить дисплеи"
              onClick={() => act('setState', { state: STATE_CHANGING_STATUS })}
            />
          )}

          <Button
            icon="envelope-o"
            content="Список сообщений"
            onClick={() => act('setState', { state: STATE_MESSAGES })}
          />

          {canBuyShuttles !== 0 && (
            <Button
              icon="shopping-cart"
              content="Купить шаттл"
              disabled={canBuyShuttles !== 1}
              // canBuyShuttles is a string detailing the fail reason
              // if one can be given
              tooltip={canBuyShuttles !== 1 ? canBuyShuttles : undefined}
              tooltipPosition="right"
              onClick={() => act('setState', { state: STATE_BUYING_SHUTTLE })}
            />
          )}

          {!!canMessageAssociates && (
            <Button
              icon="comment-o"
              content={`Отправить сообщение ${
                emagged ? '[НЕИЗВЕСТНЫЙ]' : 'Центральному Командованию'
              }`}
              disabled={!importantActionReady}
              onClick={() => setMessagingAssociates(true)}
            />
          )}

          {!!canRequestNuke && (
            <Button
              icon="radiation"
              content="Запросить коды авторизации ядерной бомбы"
              disabled={!importantActionReady}
              onClick={() => setRequestingNukeCodes(true)}
            />
          )}

          {!!emagged && !syndicate && (
            <Button
              icon="undo"
              content="Восстановить стандартные каналы связи"
              onClick={() => act('restoreBackupRoutingData')}
            />
          )}
        </Flex>
      </Section>

      {!!canMessageAssociates && messagingAssociates && (
        <MessageModal
          label={`Сообщение ${
            emagged
              ? '[НЕИЗВЕСТНОМУ КАНАЛУ СВЯЗИ]'
              : 'Центральному Командованию'
          } сквозь квантовые связи`}
          notice="Учитывайте, что каждый запрос дорого обходится корпорации. Будьте осторожны или это может привести к... расторжению контракта."
          icon="bullhorn"
          buttonText="Отправить"
          onBack={() => setMessagingAssociates(false)}
          onSubmit={(message) => {
            setMessagingAssociates(false);
            act('messageAssociates', {
              message,
            });
          }}
        />
      )}

      {!!canRequestNuke && requestingNukeCodes && (
        <MessageModal
          label="Причина запроса кодов ядерной авторизации"
          notice="Ошибка в запросе может привести к фатальным последствиям. Ответ не гарантирован."
          icon="bomb"
          buttonText="Запросить коды"
          onBack={() => setRequestingNukeCodes(false)}
          onSubmit={(reason) => {
            setRequestingNukeCodes(false);
            act('requestNukeCodes', {
              reason,
            });
          }}
        />
      )}

      {!!callingShuttle && (
        <MessageModal
          label="Эвакуация как есть"
          icon="space-shuttle"
          buttonText="Вызвать шаттл"
          minLength={callShuttleReasonMinLength}
          onBack={() => setCallingShuttle(false)}
          onSubmit={(reason) => {
            setCallingShuttle(false);
            act('callShuttle', {
              reason,
            });
          }}
        />
      )}

      {!!canSetAlertLevel &&
        showAlertLevelConfirm &&
        confirmingAlertLevelTick === alertLevelTick && (
          <Modal>
            <Flex direction="column" textAlign="center" width="300px">
              <Flex.Item fontSize="16px" mb={2}>
                Проведите ID-картой для авторизации
              </Flex.Item>

              <Flex.Item mr={2} mb={1}>
                <Button
                  icon="id-card-o"
                  content="Проводить здесь"
                  color="good"
                  fontSize="16px"
                  onClick={() =>
                    act('changeSecurityLevel', {
                      newSecurityLevel: showAlertLevelConfirm,
                    })
                  }
                />

                <Button
                  icon="times"
                  content="Cancel"
                  color="bad"
                  fontSize="16px"
                  onClick={() => setShowAlertLevelConfirm(false)}
                />
              </Flex.Item>
            </Flex>
          </Modal>
        )}

      {!!canSendToSectors && sectors.length > 0 && (
        <Section title="Союзные секторы">
          <Flex direction="column">
            {sectors.map((sectorName) => (
              <Flex.Item key={sectorName}>
                <Button
                  content={`Отправить сообщение станции в секторе ${sectorName}`}
                  disabled={!importantActionReady}
                  onClick={() => setMessagingSector(sectorName)}
                />
              </Flex.Item>
            ))}

            {sectors.length > 2 && (
              <Flex.Item>
                <Button
                  content="Отправить сообщение всем союзным станциям"
                  disabled={!importantActionReady}
                  onClick={() => setMessagingSector('all')}
                />
              </Flex.Item>
            )}
          </Flex>
        </Section>
      )}

      {!!canSendToSectors && sectors.length > 0 && messagingSector && (
        <MessageModal
          label="Отправка сообщения союзным станциям"
          notice="Учитывайте, что каждый запрос дорого обходится корпорации. Будьте осторожны или это может привести к... расторжению контракта."
          icon="bullhorn"
          buttonText="Отправить"
          onBack={() => setMessagingSector(null)}
          onSubmit={(message) => {
            act('sendToOtherSector', {
              destination: messagingSector,
              message,
            });

            setMessagingSector(null);
          }}
        />
      )}
    </Box>
  );
};

const PageMessages = (props, context) => {
  const { act, data } = useBackend(context);
  const messages = data.messages || [];

  const children = [];

  children.push(
    <Section>
      <Button
        icon="chevron-left"
        content="Назад"
        onClick={() => act('setState', { state: STATE_MAIN })}
      />
    </Section>
  );

  const messageElements = [];

  for (const [messageIndex, message] of Object.entries(messages)) {
    let answers = null;

    if (message.possibleAnswers.length > 0) {
      answers = (
        <Box mt={1}>
          {message.possibleAnswers.map((answer, answerIndex) => (
            <Button
              content={answer}
              color={message.answered === answerIndex + 1 ? 'good' : undefined}
              key={answerIndex}
              onClick={
                message.answered
                  ? undefined
                  : () =>
                      act('answerMessage', {
                        message: parseInt(messageIndex, 10) + 1,
                        answer: answerIndex + 1,
                      })
              }
            />
          ))}
        </Box>
      );
    }

    const textHtml = {
      __html: sanitizeText(message.content),
    };

    messageElements.push(
      <Section
        title={message.title}
        key={messageIndex}
        buttons={
          <Button.Confirm
            icon="trash"
            content="Удалить"
            color="red"
            onClick={() =>
              act('deleteMessage', {
                message: messageIndex + 1,
              })
            }
          />
        }
      >
        <Box dangerouslySetInnerHTML={textHtml} />

        {answers}
      </Section>
    );
  }

  children.push(messageElements.reverse());

  return children;
};

export const CommunicationsConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    authenticated,
    authorizeName,
    canLogOut,
    emagged,
    hasConnection,
    page,
    canRequestSafeCode,
    safeCodeDeliveryWait,
    safeCodeDeliveryArea,
  } = data;

  return (
    <Window width={400} height={650} theme={emagged ? 'syndicate' : undefined}>
      <Window.Content scrollable>
        {!hasConnection && <NoConnectionModal />}

        {(canLogOut || !authenticated) && (
          <Section title="Авторизация">
            <Button
              icon={authenticated ? 'sign-out-alt' : 'sign-in-alt'}
              content={
                authenticated
                  ? `Выйти${authorizeName ? ` (${authorizeName})` : ''}`
                  : 'Войти'
              }
              color={authenticated ? 'bad' : 'good'}
              onClick={() => act('toggleAuthentication')}
            />
          </Section>
        )}

        {(!!canRequestSafeCode && (
          <Section title="Экстренный запрос кодов сейфа">
            <Button
              icon="key"
              content="Запросить коды сейфа"
              color="good"
              onClick={() => act('requestSafeCodes')}
            />
          </Section>
        )) ||
          (!!safeCodeDeliveryWait && (
            <Section title="Доставка кодов сейфа">
              {`Под прилетит через \
            ${Math.round(safeCodeDeliveryWait / 10)}с`}
            </Section>
          ))}

        {!!authenticated &&
          ((page === STATE_BUYING_SHUTTLE && <PageBuyingShuttle />) ||
            (page === STATE_CHANGING_STATUS && <PageChangingStatus />) ||
            (page === STATE_MAIN && <PageMain />) ||
            (page === STATE_MESSAGES && <PageMessages />) || (
              <Box>Тут пока ничего нет :^) {page}</Box>
            ))}
      </Window.Content>
    </Window>
  );
};
