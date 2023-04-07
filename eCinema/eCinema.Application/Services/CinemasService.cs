using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class CinemasService : BaseService<Cinema, CinemaDto, CinemaUpsertDto, BaseSearchObject, ICinemasRepository>, ICinemasService
    {
        public CinemasService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CinemaUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
