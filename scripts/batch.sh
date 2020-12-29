#! /usr/bin/bash

gen(){

BASE_NAME="$(basename -- ${1} | cut -d '.' -f 1 )"
filename="$(echo $BASE_NAME | sed 's/[_|-]\([a-z]\)/\ \1/g;s/^\([a-z]\)/\ \1/g')"
p="$(cat ${1} | grep -Eo 'd="[^"]+"' | sed -r 's/d="(.+)"/h("path", { d: "\1" }, null),\n/g')"
normalized=""
for name in $filename;
do
  c="$(echo "${name:0:1}" | tr "[:lower:]" "[:upper:]")"
  normalized="${normalized}${c}${name:1}"
done
cat << EOF > "packages/components/${BASE_NAME}.ts"
import { h } from 'vue'
import Icon from '../icon/icon'

import type { FunctionalComponent } from 'vue'

const ${normalized} = function (props: any) {
  return h(
    Icon,
    props,
    {
      default: () => [${p}],
    },
  );
} as FunctionalComponent;

${normalized}.displayName = '${normalized}';

export default ${normalized};

EOF
echo "export { default as ${normalized} } from './components/${BASE_NAME}'" >> packages/index.ts
}

export -f gen

# gen ./v2/add-location.svg in case you want to use it directly
find . -name *.svg | sort | xargs -I {} bash -c 'gen "$@"' _ {}

echo "export { default as Icon } from './icon/icon'" >> packages/index.ts