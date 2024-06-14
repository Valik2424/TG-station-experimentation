import {
  Feature,
  FeatureChoiced,
  FeatureDropdownInput,
  FeatureShortTextInput,
} from '../base';

export const pda_theme: FeatureChoiced = {
  name: 'Тема ПДА',
  category: 'GAMEPLAY',
  description: 'Тема вашего ПДА.',
  component: FeatureDropdownInput,
};

export const pda_ringtone: Feature<string> = {
  name: 'Рингтон ПДА',
  description:
    'Рингтон, который вы услышите, когда кто-то отправит вам сообщение на ПДА.',
  component: FeatureShortTextInput,
};
