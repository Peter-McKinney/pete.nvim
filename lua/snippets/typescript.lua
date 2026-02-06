local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s('story', {
    t {
      "import { type Meta, type StoryObj } from '@storybook/angular';",
      '',
      'type Story = StoryObj<',
    },
    i(1, 'COMPONENT_NAME'),
    t {
      '>;',
      '',
      'const meta: Meta<',
    },
    i(1),
    t {
      '> = {',
      "    title: '",
    },
    i(2, 'COMPONENT_GROUP/COMPONENT_DESCRIPTION'),
    t {
      "',",
      "    tags: ['autodocs'],",
      '    component: ',
    },
    i(1),
    t {
      ',',
      '    decorators: [],',
      '};',
      '',
      'export default meta;',
      '',
      'export const Default: Story = {',
      '    args: {',
      '',
      '    },',
      '};',
    },
  }),

  s('http', {
    t {
      'private http = inject(HttpClient);',
      '',
      'fetch(request: FeedbackRequest): Observable<NewResponse | null> {',
      'const { headers, params } = FeedbackRequestService.getFeedbackHeadersParams(request);',
      '',
      'return this.http',
      '.get<NewResponse>(ApiUrlService.getEndpoint(), {',
      'headers,',
      'params,',
      '})',
      '.pipe(',
      'catchError((error: HttpErrorResponse) => {',
      'console.error(error);',
      'return of(null);',
      '}),',
      ');',
      '}',
    },
  }),

  s('store', {
    t {

      'private newRequest = SignalStore.create<FeedbackRequest>(null);',
      'private newHttpService = inject(newHttpService);',
      '',
      'private readonly newResponseStore = SignalStore.getSignal<FeedbackRequest, ResponseType>(',
      'this.newRequest,',
      '(request) => this.newHttpService.fetch(request),',
      ');',
      '',
      'readonly response = computed<Nullable<ResponseType>>(() => {',
      'return this.newResponseStore.data();',
      '});',
      '',
      'readonly loading = this.newResponseStore.loading;',
      '',
      'fetch(request: FeedbackRequest): void {',
      'this.newRequest.set(request);',
      '}',
    },
  }),
}
