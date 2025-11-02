# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy complete]
  before_action :authorize_parent, only: %i[new create edit update destroy]

  def index
    if current_user.adult?
      # Parents see all tasks for kids in their group
      @tasks = Task.where(assigned_user_id: current_user.group.users.pluck(:id))
                   .includes(:assigned_user, :created_by)
                   .order(created_at: :desc)
      @children = current_user.group.users.where(role: 'child')
    else
      # Kids see only their own tasks
      @tasks = current_user.tasks.order(created_at: :desc)
    end
  end

  def show; end

  def new
    @task = Task.new
    @children = current_user.group.users.where(role: 'child')
  end

  def create
    @task = Task.new(task_params)
    @task.created_by = current_user

    if @task.save
      redirect_to tasks_path, notice: 'Task created successfully! 🎉'
    else
      @children = current_user.group.users.where(role: 'child')
      render :new
    end
  end

  def edit
    @children = current_user.group.users.where(role: 'child')
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'Task updated successfully!'
    else
      @children = current_user.group.users.where(role: 'child')
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Task deleted!'
  end

  def complete
    if @task.complete!
      points_earned = @task.points
      render json: {
        success: true,
        points_earned: points_earned,
        new_xp: @task.assigned_user.xp,
        new_bank: @task.assigned_user.bank,
        new_level: @task.assigned_user.level
      }
    else
      render json: { success: false, error: 'Could not complete task' }, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :points, :assigned_user_id, :due_date, :repeating, :repeat_frequency)
  end

  def authorize_parent
    redirect_to tasks_path, alert: 'Only parents can do that!' unless current_user.adult?
  end
end
