import { registerPlugin } from '@capacitor/core';

import type { GimmeImagePlugin } from './definitions';

const GimmeImage = registerPlugin<GimmeImagePlugin>('GimmeImage', {
  web: () => import('./web').then(m => new m.GimmeImageWeb()),
});

export * from './definitions';
export { GimmeImage };
