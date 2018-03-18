import { Segment, Grid, Button, Icon } from 'semantic-ui-react';
import Logo from 'components/misc/Logo';
import Navbar from 'components/layout/Navbar';
import * as React from 'react';
import 'components/layout/MenuLayout.scss';

interface MenuLayoutProps {
  menu: JSX.Element;
  content: JSX.Element;
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
    const rightSide = (
      <React.Fragment>
        <Segment inverted id="MenuLayout-navbar">
          <Grid>
            <Grid.Column>
              <Button icon size="large" onClick={this.toggleVisibility}>
                <Icon name={menuVisible ? 'angle double left' : 'angle double right'}/>
              </Button>
            </Grid.Column>
            <Grid.Column>
              <Navbar/>
            </Grid.Column>
          </Grid>
        </Segment>
        <div id="MenuLayout-content">{content}</div>
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
          <div id="MenuLayout-menu-inner">{menu}</div>
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
