import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Button, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  timing: BooleanLike;
  minutes: number;
  seconds: number;
  flash_charging: BooleanLike;
};

export const BrigTimer = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { timing, minutes, seconds, flash_charging } = data;
  return (
    <Window width={300} height={138}>
      <Window.Content scrollable>
        <Section
          title="Таймер камеры"
          buttons={
            <>
              <Button
                icon="clock-o"
                content={timing ? 'Стоп' : 'Старт'}
                selected={timing}
                onClick={() => act(timing ? 'stop' : 'start')}
              />
              <Button
                icon="lightbulb-o"
                content={flash_charging ? 'Перезарядка' : 'Вспышка'}
                disabled={flash_charging}
                onClick={() => act('flash')}
              />
            </>
          }
        >
          <Button
            icon="fast-backward"
            onClick={() => act('time', { adjust: -600 })}
          />
          <Button
            icon="backward"
            onClick={() => act('time', { adjust: -100 })}
          />{' '}
          {String(minutes).padStart(2, '0')}:{String(seconds).padStart(2, '0')}{' '}
          <Button icon="forward" onClick={() => act('time', { adjust: 100 })} />
          <Button
            icon="fast-forward"
            onClick={() => act('time', { adjust: 600 })}
          />
          <br />
          <Button
            icon="hourglass-start"
            content="Короткий"
            onClick={() => act('preset', { preset: 'short' })}
          />
          <Button
            icon="hourglass-start"
            content="Средний"
            onClick={() => act('preset', { preset: 'medium' })}
          />
          <Button
            icon="hourglass-start"
            content="Долгий"
            onClick={() => act('preset', { preset: 'long' })}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
