import React from 'react';
import agent from '../../agent';

const Tags = props => {
  const tags = props.tags;
  if (tags) {
    return (
      <div className="tag-list">
        {
          tags.map(tag => {
            const handleClick = ev => {
              ev.preventDefault();
              props.onClickTag(tag.tag, page => agent.Articles.byTag(tag.tag, page), agent.Articles.byTag(tag.tag));
            };

            return (
              <a
                href=""
                className="tag-default tag-pill"
                key={tag.id}
                onClick={handleClick}>
                {tag.tag}
              </a>
            );
          })
        }
      </div>
    );
  } else {
    return (
      <div>Loading Tags...</div>
    );
  }
};

export default Tags;
