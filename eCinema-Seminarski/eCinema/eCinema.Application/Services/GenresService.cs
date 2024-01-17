using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application
{
    public class GenresService : BaseService<Genre, GenreDto, GenreUpsertDto, GenreSearchObject, IGenresRepository>, IGenresService
    {
        public GenresService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<GenreUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
