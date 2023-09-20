import { WebPlugin } from '@capacitor/core';

import type { GimmeImagePlugin } from './definitions';

export class GimmeImageWeb extends WebPlugin implements GimmeImagePlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
