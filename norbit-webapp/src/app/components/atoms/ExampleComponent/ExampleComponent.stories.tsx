import { ExampleComponent } from './ExampleComponent';

export default {
  title: 'atom/ExampleComponent',
  component: ExampleComponent,
  args : { children : 'Button', size : "small" },
};

export const Default = {}

export const Large = { args : { size : 'large', children: "Large" } }
export const Medium = { args : { size : 'medium', children: "Medium" } }
export const Small = { args : { size : 'small', children: "Small" } }
