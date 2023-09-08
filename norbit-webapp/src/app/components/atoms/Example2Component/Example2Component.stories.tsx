import { Example2Component } from './Example2Component';

export default {
  title: 'atom/Example2Component',
  component: Example2Component,
  args : { children : 'Button', size : "small" },
};

export const Default = {}

export const Large = { args : { size : 'large', children: "Completely" } }
export const Medium = { args : { size : 'medium', children: "New" } }
export const Small = { args : { size : 'small', children: "Buttons" } }
