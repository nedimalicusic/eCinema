using eCinema.Core;
using FluentValidation.Results;

namespace eCinema.Application
{
    public class ValidationErrorProfile : BaseProfile
    {
        public ValidationErrorProfile()
        {
            CreateMap<ValidationFailure, ValidationError>();
        }
    }
}
