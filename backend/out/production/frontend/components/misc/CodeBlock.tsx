import * as React from 'react';
import SyntaxHighlighter from 'react-syntax-highlighter/dist/light';
import 'syntaxHighlighting/highlightjs-highlighting';
import 'Animation.less';

interface CodeBlockProps {
  children: string;
  language: string;
}

const charCount = (str: string, char: string) => {
  let count = 0;
  for (let i = 0; i < str.length; i += 1) {
    if (str.charAt(i) === char) { count++; }
  }
  return count;
};

const CodeBlock: React.StatelessComponent<CodeBlockProps> = ({ children: code, language }: CodeBlockProps) => {
  const numLines = 1 + charCount(code, '\n');
  return (
    <div className="shadow-hover">
      <SyntaxHighlighter
        wrapLines
        useInlineStyles={false}
        showLineNumbers={numLines >= 5}
        language={language}
      >
        {code}
      </SyntaxHighlighter>
    </div>
  );
};

export default CodeBlock;
