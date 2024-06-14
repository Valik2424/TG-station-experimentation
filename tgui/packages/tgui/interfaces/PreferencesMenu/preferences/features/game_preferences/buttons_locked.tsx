import { CheckboxInput, FeatureToggle } from '../base';

export const buttons_locked: FeatureToggle = {
  name: 'Lock action buttons',
  name_ru: 'Закрепить кнопки действий',
  category: 'GAMEPLAY',
  description: 'Когда включено, кнопки действий будут закреплены на месте.',
  component: CheckboxInput,
};
