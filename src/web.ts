import { WebPlugin } from '@capacitor/core';

import type { GimmeImagePlugin, GimmeOptions } from './definitions';

export class GimmeImageWeb extends WebPlugin implements GimmeImagePlugin {
  gimmeMediaItem(options?: GimmeOptions): Promise<MediaAsset> {
    console.log('getMedias', options);
    throw this.unimplemented('Not implemented on web.');
  }
}
