export interface GimmeImagePlugin {
  /**
    * Get media item from camera roll referenced by the platform specific identifier.
    */
  gimmeMediaItem(options?: GimmeOptions): Promise<MediaAsset>;
}

export interface GimmeOptions {
    /**
     * Platform-specific identifier
     */
    identifier: string;
}

export interface MediaAsset {
  /**
   * Platform-specific identifier
   */
  identifier: string;
  /**
   * Data for a photo asset as a base64 encoded string (JPEG only supported)
   */
  data: string;
  /**
   * ISO date string for creation date of asset
   */
  creationDate: string;
  /**
   * Full width of original asset
   */
  fullWidth: number;
  /**
   * Full height of original asset
   */
  fullHeight: number;
  /**
   * Width of thumbnail preview
   */
  thumbnailWidth: number;
  /**
   * Height of thumbnail preview
   */
  thumbnailHeight: number;
  /**
   * Location metadata for the asset
   */
  location: MediaLocation;
}

export interface MediaLocation {
  /**
   * GPS latitude image was taken at
   */
  latitude: number;
  /**
   * GPS longitude image was taken at
   */
  longitude: number;
  /**
   * Heading of user at time image was taken
   */
  heading: number;
  /**
   * Altitude of user at time image was taken
   */
  altitude: number;
  /**
   * Speed of user at time image was taken
   */
  speed: number;
}