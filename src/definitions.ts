export interface GimmeImagePlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
