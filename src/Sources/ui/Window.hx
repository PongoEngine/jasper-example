/*
 * Copyright (c) 2018 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package ui;

import jasper.Variable;
import jasper.Constraint;
import jasper.Solver;
import jasper.Strength;

class Window
{
    public var color (default, null) : Int;
    public var x (default, null) : Length;
    public var y (default, null) : Length;
    public var width (default, null) : Length;
    public var height (default, null) : Length;
    public var children (default, null) :Array<Window>;

    public function new(color :Int, x :Length, y :Length, width :Length, height :Length) : Void
    {
        this.color = color;
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.children = [];

        _x = new Variable("_x");
        _y = new Variable("_y");
        _width = new Variable("_width");
        _height = new Variable("_height");

        _constraints = [];

        switch x {
            case PX(val, str): _constraints.push((_x == val) | str);
            case PERCENT(val, str):
        }
        switch y {
            case PX(val, str): _constraints.push((_y == val) | str);
            case PERCENT(val, str):
        }
        switch width {
            case PX(val, str): _constraints.push((_width == val) | str);
            case PERCENT(val, str):
        }
        switch height {
            case PX(val, str): _constraints.push((_height == val) | str);
            case PERCENT(val, str):
        }
    }

    public function addWindow(childWindow :Window) : Window
    {
        var x = _x + 0;
        var y = _y + 0;
        if(children.length > 0) {
            var last = children[children.length-1];
            y = last._y + last._height;
        }
        switch childWindow.x {
            case PX(val, str): 
                _constraints.push((childWindow._x == x+val) | Strength.REQUIRED);
            case PERCENT(val, str):
                _constraints.push((childWindow._x == x+(val*_width)) | Strength.REQUIRED);
        }
        switch childWindow.y {
            case PX(val, str): 
                _constraints.push((childWindow._y == y+val) | Strength.REQUIRED);
            case PERCENT(val, str):
                _constraints.push((childWindow._y == y+(val*_height)) | Strength.REQUIRED);
        }
        switch childWindow.width {
            case PX(val, str): 
                _constraints.push((_width == val) | Strength.REQUIRED);
            case PERCENT(val, str):
                _constraints.push((childWindow._width == _width * val) | Strength.REQUIRED);
        }
        switch childWindow.height {
            case PX(val, str): 
                _constraints.push((_height == val) | Strength.REQUIRED);
            case PERCENT(val, str):
                _constraints.push((childWindow._height == _height * val) | Strength.REQUIRED);
        }

        children.push(childWindow);
        return this;
    }

    public function addToSolver(solver :Solver) : Window
    {
        for(constraint in _constraints) {
            solver.addConstraint(constraint);
        }
        for(child in children) {
            child.addToSolver(solver);
        }
        return this;
    }

    public function makeEdit(solver :Solver) : Void
    {
        solver.addEditVariable(_width, Strength.MEDIUM);
        solver.addEditVariable(_height, Strength.MEDIUM);
    }

    public function setSize(width :Float, height :Float, solver :Solver) : Void
    {
        solver.suggestValue(_width, width);
        solver.suggestValue(_height, height);
        solver.updateVariables();
    }

    public function render(framebuffer: kha.Framebuffer): Void 
    {
		framebuffer.g2.color = this.color;
        framebuffer.g2.fillRect(_x.m_value, _y.m_value, _width.m_value, _height.m_value);

        for(child in this.children) {
            child.render(framebuffer);
        }
	}

    private var _x :Variable;
    private var _y :Variable;
    private var _width :Variable;
    private var _height :Variable;
    private var _constraints :Array<Constraint>;
}