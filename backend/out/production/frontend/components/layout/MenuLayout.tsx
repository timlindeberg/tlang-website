import { Segment, Grid, Button, Icon } from 'semantic-ui-react';
import Logo from 'components/misc/Logo';
import Navbar from 'components/layout/Navbar';
import * as React from 'react';
import 'components/layout/MenuLayout.less';

interface MenuLayoutProps {
  menu: (state: MenuLayoutState) => JSX.Element;
  content: (state: MenuLayoutState) => JSX.Element;
}

interface MenuLayoutState {
  menuVisible: boolean;
}

export default class MenuLayout extends React.Component<MenuLayoutProps, MenuLayoutState> {

  state: MenuLayoutState = {  menuVisible: true, };

  toggleVisibility = (): void => this.setState(prev => ({ menuVisible: !prev.menuVisible }));

  render() {
    const { menu, content } = this.props;
    const { menuVisible } = this.state;
    const rightSideStyle = menuVisible ? { borderRadius: '1em 0 0 0' } : {};
    const rightSide = (
      <React.Fragment>
        <Segment inverted id="MenuLayout-navbar">
          <Grid>
            <Grid.Column verticalAlign="middle">
              <Button icon onClick={this.toggleVisibility}>
                <Icon name={menuVisible ? 'angle double left' : 'angle double right'}/>
              </Button>
            </Grid.Column>
            <Grid.Column>
              <Navbar/>
            </Grid.Column>
          </Grid>
        </Segment>
        <div id="MenuLayout-content" style={rightSideStyle}>
          {content(this.state)}
        </div>
      </React.Fragment>
    );

    if (!menuVisible) {
      return rightSide;
    }

    const leftSide = (
      <React.Fragment>
        <Segment inverted id="MenuLayout-logo">
          <Logo size={2.5}/>
        </Segment>
        <Segment inverted id="MenuLayout-menu">
          <div id="MenuLayout-menu-inner">
            {menu(this.state)}
          </div>
        </Segment>
      </React.Fragment>
    );

    return (
      <Grid>
        <Grid.Column width={3} id="MenuLayout-left">{leftSide}</Grid.Column>
        <Grid.Column width={13} id="MenuLayout-right">{rightSide}</Grid.Column>
      </Grid>
    );
  }
}
