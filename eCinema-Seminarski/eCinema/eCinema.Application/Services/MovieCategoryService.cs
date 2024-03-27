using AutoMapper;
using eCinema.Application.Interfaces.Services;
using eCinema.Core;
using eCinema.Core.Entities;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.Repositories;
using FluentValidation;

namespace eCinema.Application.Services
{
    public class MovieCategoryService : BaseService<MovieCategory, MovieCategoryDto, MovieCategoryUpsertDto, BaseSearchObject, IMovieCategoryRepository>, IMovieCategoryService
    {
        public MovieCategoryService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<MovieCategoryUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
