import { multiline } from 'common/string';
import { Feature, FeatureDropdownInput } from '../base';

export const preferred_map: Feature<string> = {
  name: 'Preferred map',
  name_ru: 'Любимая карта',
  category: 'GAMEPLAY',
  description: multiline`
    Во время ротации карт, предпочитать эту карту.
    Это не влияет на голосование за карту, только на случайную ротацию,
    когда голосование не проводится.
  `,
  component: FeatureDropdownInput,
};
